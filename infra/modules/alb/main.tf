################################################################################
# ALB ACCESS LOG BUCKET
################################################################################

resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.project_name}-alb-logs-322172729886"
}

resource "aws_s3_bucket_versioning" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

################################################################################
# ALB
################################################################################

resource "aws_lb" "this" {
  name               = "${var.project_name}-alb"

  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group
  ]

  subnets = var.public_subnet_ids

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    enabled = true
  }

  tags = {
    Name = "${var.project_name}-alb"
  }

  depends_on = [
    aws_s3_bucket_policy.alb_logs
  ]
}

################################################################################
# TARGET GROUP
################################################################################

resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-tg"

  port        = 80
  protocol    = "HTTP"

  target_type = "ip"

  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"

    healthy_threshold   = 2
    unhealthy_threshold = 3

    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

################################################################################
# HTTP LISTENER
################################################################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}