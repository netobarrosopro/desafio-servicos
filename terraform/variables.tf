variable "aws_region" {
  description = "Região AWS para os recursos"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome único do bucket S3"
  type        = string
  default     = "desafioservico-static-site"
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "desafioservico-eks"
}

variable "node_instance_type" {
  description = "Tipo de instância para nodes EKS"
  type        = string
  default     = "t3.medium"
}

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
  default     = "desafioservico-daily-upload"
}

variable "s3_destination_bucket" {
  description = "Nome do bucket S3 de destino"
  type        = string
  default     = "desafioservico-lambda-uploads"
}
