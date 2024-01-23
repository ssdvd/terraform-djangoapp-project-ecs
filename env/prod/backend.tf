# Configuração do backend para armazenar o estado do Terraform no Amazon S3.
terraform {
  backend "s3" {
    bucket = "terraform-state-djangoapp-prod"  # Nome do bucket S3 para armazenar o estado do Terraform.
    key    = "prod/terraform.tfstate"         # Caminho para o arquivo de estado dentro do bucket.
    region = "us-east-1"                       # Região AWS onde o bucket está localizado.
  }
}
