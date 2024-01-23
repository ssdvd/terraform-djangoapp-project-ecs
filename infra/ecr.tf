# Recurso para criar um repositório no Amazon ECR.
resource "aws_ecr_repository" "ecr_repo" {
  name = var.repo  # Nome do repositório definido pela variável "repo".
}
