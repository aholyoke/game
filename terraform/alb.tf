resource "aws_alb" "main" {
  name            = "sayless-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "app" {
  name_prefix = "tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_acm_certificate" "main" {
  domain = "*.sayless.lol"
}


resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.main.arn

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.app.arn
  }
}


resource "aws_alb_listener" "unsecure" {
  load_balancer_arn = aws_alb.main.id
  port = 8080
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.app.arn
  }
}
