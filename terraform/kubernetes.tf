# Deployment do backend
resource "kubernetes_deployment" "backend" {
  metadata {
    name = "desafioservico-backend"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "desafioservico-backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "desafioservico-backend"
        }
      }

      spec {
        container {
          image = "${aws_ecr_repository.backend_repo.repository_url}:latest"  # Push sua imagem aqui
          name  = "backend"
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

# Service
resource "kubernetes_service" "backend" {
  metadata {
    name = "desafioservico-backend"
  }

  spec {
    selector = {
      app = "desafioservico-backend"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}