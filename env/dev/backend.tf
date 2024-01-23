# Configuração do backend para armazenar o estado do Terraform no Amazon S3 - Ambiente de Desenvolvimento.
terraform {
  backend "s3" {
    bucket = "terraform-state-djangoapp-dev"  # Nome do bucket S3 para armazenar o estado do Terraform.
    key    = "dev/terraform.tfstate"          # Caminho para o arquivo de estado dentro do bucket.
    region = "us-east-1"                       # Região AWS onde o bucket está localizado.
  }
}
