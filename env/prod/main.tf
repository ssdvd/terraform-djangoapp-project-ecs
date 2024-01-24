# Uso do módulo "infra" para criar recursos de infraestrutura para o ambiente de produção.
module "prod" {
  source = "../../infra" # Caminho para o diretório que contém o módulo "infra".

  repo     = "prod" # Nome do repositório passado como variável para o módulo.
  cargoiam = "prod" # Nome do cargo IAM passado como variável para o módulo.
  env      = "prod"
}

output "dns_alb" {
  value = module.prod.ip_alb
}
