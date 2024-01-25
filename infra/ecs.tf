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


resource "aws_ecs_task_definition" "djangoapp" {
  family                   = "djangoapp"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.role_ecs.arn
  container_definitions = jsonencode([
  {
    "name"      = "djangoapp"
    "image"     = "027662851187.dkr.ecr.us-east-1.amazonaws.com/prod:latest"
    "cpu"       = 256
    "memory"    = 512
    "essential" = true
    "portMappings" = [
      {
        "containerPort" = 8000
        "hostPort"      = 8000
      }
    ]
  }
])
}

resource "aws_ecs_service" "djangoapp" {
  name            = "djangoapp"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.djangoapp.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_alb_djangoapp.arn
    container_name   = "djangoapp"
    container_port   = 8000
  }

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.private_ecs.id]
  }
}
