########################################
# ECS LOG GROUP
########################################

resource "aws_cloudwatch_log_group" "ecs" {

  name = "/ecs/${var.project_name}"

  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-ecs-log-group"
  }
}

########################################
# CPU UTILIZATION ALARM
########################################

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {

  alarm_name = "${var.project_name}-ecs-cpu-high"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/ECS"

  period = 300

  statistic = "Average"

  threshold = 80

  alarm_description = "ECS CPU Utilization High"

  dimensions = {

    ClusterName = var.ecs_cluster_name

    ServiceName = var.ecs_service_name
  }

  alarm_actions = [
    var.sns_topic_arn
  ]
}

########################################
# MEMORY UTILIZATION ALARM
########################################

resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {

  alarm_name = "${var.project_name}-ecs-memory-high"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "MemoryUtilization"

  namespace = "AWS/ECS"

  period = 300

  statistic = "Average"

  threshold = 80

  alarm_description = "ECS Memory Utilization High"

  dimensions = {

    ClusterName = var.ecs_cluster_name

    ServiceName = var.ecs_service_name
  }

  alarm_actions = [
    var.sns_topic_arn
  ]
}

########################################
# ALB 5XX ERROR ALARM
########################################

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {

  alarm_name = "${var.project_name}-alb-5xx-errors"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1

  metric_name = "HTTPCode_ELB_5XX_Count"

  namespace = "AWS/ApplicationELB"

  period = 300

  statistic = "Sum"

  threshold = 5

  alarm_description = "ALB 5XX Errors"

  dimensions = {

    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = [
    var.sns_topic_arn
  ]
}

########################################
# SNS TOPIC
########################################

resource "aws_sns_topic" "alerts" {

  name = "${var.project_name}-alerts"
}

########################################
# SNS EMAIL SUBSCRIPTION
########################################

resource "aws_sns_topic_subscription" "email" {

  topic_arn = aws_sns_topic.alerts.arn

  protocol = "email"

  endpoint = var.alert_email
}