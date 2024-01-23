# Recurso para criar um grupo de segurança (security group) para o Application Load Balancer (ALB).
resource "aws_security_group" "alb" {
  name   = "alb_ecs"
  vpc_id = module.vpc.vpc_id
}

# Regra de segurança de entrada para permitir tráfego na porta 8000 para o ALB.
resource "aws_security_group_rule" "port_alb_in" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

# Regra de segurança de saída para permitir tráfego na porta 8000 a partir do ALB.
resource "aws_security_group_rule" "port_alb_eg" {
  type              = "egress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

# Recurso para criar um grupo de segurança para as instâncias ECS na rede privada.
resource "aws_security_group" "private_ecs" {
  name   = "private_ecs"
  vpc_id = module.vpc.vpc_id
}

# Regra de segurança de entrada para permitir todo o tráfego originado do ALB para as instâncias ECS.
resource "aws_security_group_rule" "ecs_in" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.private_ecs.id
}

# Regra de segurança de saída para permitir todo o tráfego das instâncias ECS para qualquer destino.
resource "aws_security_group_rule" "ecs_eg" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_ecs.id
}
