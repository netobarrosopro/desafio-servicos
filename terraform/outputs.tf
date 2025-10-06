output "website_endpoint" {
  description = "Endpoint do site estático"
  value       = "http://${aws_s3_bucket.static_site.bucket}.s3-website-${var.aws_region}.amazonaws.com"
}

output "alb_endpoint" {
  description = "Endpoint do ALB para backend (que serve frontend)"
  value       = kubernetes_service.backend.status[0].load_balancer[0].ingress[0].hostname
}

output "ecr_repository_url" {
  value = aws_ecr_repository.backend_repo.repository_url
}