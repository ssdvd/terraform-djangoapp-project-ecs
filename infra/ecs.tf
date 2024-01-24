module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = var.env
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 1
      }
    }
  }
  cluster_settings = {
    name  = "containerInsights"
    value = "enabled"
  }
}
