################################################################################
# SNS TOPIC
################################################################################

resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"
}

################################################################################
# ECS CPU
################################################################################

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {

  alarm_name = "${var.project_name}-ecs-cpu-high"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/ECS"

  period    = 300
  statistic = "Average"

  threshold = 80

  alarm_description = "ECS CPU utilization is above 80%"

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

################################################################################
# ECS MEMORY
################################################################################

resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {

  alarm_name = "${var.project_name}-ecs-memory-high"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2

  metric_name = "MemoryUtilization"
  namespace   = "AWS/ECS"

  period    = 300
  statistic = "Average"

  threshold = 80

  alarm_description = "ECS memory utilization is above 80%"

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

################################################################################
# RDS CPU
################################################################################

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {

  alarm_name = "${var.project_name}-rds-cpu-high"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/RDS"

  period    = 300
  statistic = "Average"

  threshold = 80

  dimensions = {
    DBInstanceIdentifier = var.rds_id
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

################################################################################
# ALB 5XX
################################################################################

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {

  alarm_name = "${var.project_name}-alb-5xx-errors"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1

  metric_name = "HTTPCode_Target_5XX_Count"
  namespace   = "AWS/ApplicationELB"

  statistic = "Sum"
  period    = 300

  threshold = 5

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}