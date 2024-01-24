resource "aws_lb" "alb_djangoapp" {
  name            = "ecs-djangoapp"
  security_groups = [aws_security_group.alb.id]
  subnets         = tolist(module.vpc.public_subnets)

}

resource "aws_lb_target_group" "tg_alb_djangoapp" {
  name        = "ecs-djangoapp"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_lb_listener" "ls_http_alb_djangoaap" {
  load_balancer_arn = aws_lb.alb_djangoapp.arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_alb_djangoapp.arn
  }
}

output "ip_alb" {
  value = aws_lb.alb_djangoapp.dns_name
}
