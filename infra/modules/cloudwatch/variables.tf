variable "project_name" {
  type = string
}

########################################
# ECS
########################################

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

########################################
# ALB
########################################

variable "alb_arn_suffix" {
  type = string
}

########################################
# ALERTING
########################################

variable "alert_email" {
  type = string
}

variable "sns_topic_arn" {
  type    = string
  default = null
}