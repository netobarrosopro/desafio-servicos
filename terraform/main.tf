# Cria o bucket S3
resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name
}

# Configura o bucket para hospedagem de site estático
resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"  # Crie um error.html simples na app se necessário
  }
}

# Política para tornar o bucket público (leitura apenas)
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}

# Desabilita bloqueio de acesso público (necessário para site público)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Habilita versionamento no bucket (melhor prática para recuperação)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.static_site.id
  versioning_configuration {
    status = "Enabled"
  }
}

# VPC para EKS (melhor prática: subnets públicas e privadas)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
      instance_types = [var.node_instance_type]
    }
  }

  # Addons para ALB Ingress
  cluster_addons = {
    aws-load-balancer-controller = {
      most_recent = true
    }
  }
}

# ECR para imagem Docker do backend
resource "aws_ecr_repository" "backend_repo" {
  name                 = "desafioservico-backend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}


# Bucket S3 de destino para uploads do Lambda
resource "aws_s3_bucket" "lambda_uploads" {
  bucket = var.s3_destination_bucket
}

resource "aws_s3_bucket_versioning" "lambda_uploads_versioning" {
  bucket = aws_s3_bucket.lambda_uploads.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Role IAM para o Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Política de permissão para o Lambda escrever no S3
resource "aws_iam_role_policy" "lambda_s3_write" {
  name   = "lambda_s3_write_policy"
  role   = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${aws_s3_bucket.lambda_uploads.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Função Lambda
resource "aws_lambda_function" "daily_upload" {
  function_name = var.lambda_function_name
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = "lambda_function.zip"  # Crie este arquivo manualmente (veja abaixo)

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.lambda_uploads.bucket
    }
  }
}

# Permissão para EventBridge invocar o Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.daily_upload.function_name
  principal     = "events.amazonaws.com"
}

# Regra do EventBridge para agendamento diário às 10:00 AM (-03)
resource "aws_cloudwatch_event_rule" "daily_upload_rule" {
  name                = "daily-upload-rule"
  description         = "Dispara o Lambda diariamente às 10:00 AM"
  schedule_expression = "cron(0 13 * * ? *)"  # 10:00 AM UTC-3 (13:00 UTC)
}

# Alvo do EventBridge (Lambda)
resource "aws_cloudwatch_event_target" "daily_upload_target" {
  rule      = aws_cloudwatch_event_rule.daily_upload_rule.name
  target_id = "DailyUploadLambda"
  arn       = aws_lambda_function.daily_upload.arn
}