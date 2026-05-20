resource "aws_lb" "this" {

  name               = "${var.project_name}-alb"

  internal           = false

  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group
  ]

  subnets = var.public_subnets

  enable_deletion_protection = false

  idle_timeout = 60

  tags = {
    Name = "${var.project_name}-alb"
  }
}

########################################
# TARGET GROUP
########################################

resource "aws_lb_target_group" "this" {

  name = "${var.project_name}-tg"

  port     = var.container_port
  protocol = "HTTP"

  target_type = "instance"

  vpc_id = var.vpc_id

  health_check {

    enabled = true

    path = "/"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold   = 2

    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

########################################
# HTTP LISTENER
########################################

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.this.arn

  port     = 80
  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.this.arn
  }
}

########################################
# HTTPS LISTENER (OPTIONAL)
########################################

resource "aws_lb_listener" "https" {

  count = var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.this.arn

  port     = 443
  protocol = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = var.acm_certificate_arn

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.this.arn
  }
}