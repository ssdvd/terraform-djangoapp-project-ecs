# terraform-djangoapp-project-ecs

Infraestrutura na AWS para rodar o [app-cadastro-django](https://github.com/ssdvd/app-cadastro-django) em containers: Amazon ECS com Fargate, Application Load Balancer e VPC própria, tudo provisionado com Terraform.

Terceira versão da infraestrutura desse app:

| Repositório | Arquitetura |
| --- | --- |
| [terraform-djangoapp-project](https://github.com/ssdvd/terraform-djangoapp-project) | Uma instância EC2 configurada com Ansible |
| [terraform-djangoapp-project-as-lb](https://github.com/ssdvd/terraform-djangoapp-project-as-lb) | Auto Scaling Group e Load Balancer |
| **terraform-djangoapp-project-ecs** (este) | Containers no ECS com Fargate |

## Arquitetura

```
              ┌───────────────────────────┐
usuários ───► │ Application Load Balancer │ :8000   (subnets públicas)
              └─────────────┬─────────────┘
                            │
              ┌─────────────▼─────────────┐
              │ ECS Service (Fargate)     │ 3 tasks (subnets privadas)
              │ imagem vinda do ECR       │
              └───────────────────────────┘
```

| Arquivo | Recursos |
| --- | --- |
| [`infra/vpc.tf`](infra/vpc.tf) | VPC `10.0.0.0/16` com 3 subnets públicas, 3 privadas e NAT Gateway, usando o módulo `terraform-aws-modules/vpc` |
| [`infra/sg.tf`](infra/sg.tf) | Security group do ALB (porta `8000`) e das tasks (entrada só a partir do ALB) |
| [`infra/alb.tf`](infra/alb.tf) | Application Load Balancer, target group e listener na porta `8000` |
| [`infra/ecr.tf`](infra/ecr.tf) | Repositório de imagens no ECR |
| [`infra/iam.tf`](infra/iam.tf) | Role de execução com permissão para puxar imagens do ECR e gravar logs |
| [`infra/ecs.tf`](infra/ecs.tf) | Cluster ECS com Fargate e Container Insights, task definition (256 CPU / 512 MB) e service com 3 tasks |
| [`env/prod`](env/prod) | Ambiente de produção: chama o módulo e guarda o state em um bucket S3 |
| [`env/dev`](env/dev) | Backend do state de desenvolvimento (o `main.tf` do ambiente ainda não foi criado) |

As tasks ficam em subnets privadas e só recebem tráfego do Load Balancer; a saída para a internet passa pelo NAT Gateway.

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install)
- AWS CLI com credenciais configuradas
- Docker, para buildar e enviar a imagem
- Um bucket S3 para o state remoto (ajuste o nome em [`env/prod/backend.tf`](env/prod/backend.tf))
- Um banco MySQL acessível pelas tasks, configurado no `settings.py` do app

## Como usar

1. Crie a infraestrutura:

   ```bash
   cd env/prod
   terraform init
   terraform apply
   ```

2. Builde a imagem a partir do [app-cadastro-django](https://github.com/ssdvd/app-cadastro-django) e envie para o ECR criado (repositório `prod`):

   ```bash
   docker build -t djangoapp .
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin SUA_CONTA.dkr.ecr.us-east-1.amazonaws.com
   docker tag djangoapp SUA_CONTA.dkr.ecr.us-east-1.amazonaws.com/prod:latest
   docker push SUA_CONTA.dkr.ecr.us-east-1.amazonaws.com/prod:latest
   ```

3. O endereço da imagem está fixo na task definition em [`infra/ecs.tf`](infra/ecs.tf); troque pelo da sua conta e rode `terraform apply` de novo.

O output `dns_alb` mostra o DNS do Load Balancer; a aplicação responde em `http://DNS_DO_ALB:8000`. Para remover tudo, rode `terraform destroy`.

> O NAT Gateway e o Load Balancer são cobrados por hora. Destrua o ambiente quando terminar de estudar.
