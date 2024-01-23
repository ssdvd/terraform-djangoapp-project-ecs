# Módulo para criar uma VPC (Virtual Private Cloud) usando o módulo oficial do Terraform para AWS.
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  # Nome da VPC.
  name = "vpc_ecs"

  # Bloco CIDR para a VPC.
  cidr = "10.0.0.0/16"

  # Zonas de disponibilidade da AWS onde as sub-redes serão criadas.
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # Sub-redes privadas para instâncias ECS.
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  # Sub-redes públicas para o Application Load Balancer (ALB).
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # Ativar ou desativar o uso de um NAT Gateway.
  enable_nat_gateway = true
}
