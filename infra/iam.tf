# Recurso para criar uma função IAM.
resource "aws_iam_role" "funcao" {
  name = "funcao_${var.cargoiam}"  # Nome da função IAM, usando a variável "cargoiam".
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })
}

# Recurso para associar uma política à função IAM para permissões relacionadas ao ECR (Elastic Container Registry).
resource "aws_iam_role_policy" "ecs_ecr" {
  name = "ecs_ecr"
  role = aws_iam_role.funcao.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Recurso para criar um perfil de instância IAM associado à função IAM.
resource "aws_iam_instance_profile" "test_profile" {
  name = "perfil_${var.cargoiam}"  # Nome do perfil de instância, usando a variável "cargoiam".
  role = aws_iam_role.funcao.name
}
