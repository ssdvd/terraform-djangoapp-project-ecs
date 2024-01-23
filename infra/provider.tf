# Configuração do bloco "terraform", onde são definidos os provedores necessários.
terraform {
  required_providers {
    # Provedor AWS com a fonte do provedor e a versão desejada.
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Definição do provedor AWS com a região especificada.
provider "aws" {
  region = "us-east-1"  # Especifique a região AWS desejada aqui.
}
