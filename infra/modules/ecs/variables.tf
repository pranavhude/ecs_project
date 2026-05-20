########################################
# GENERAL
########################################

variable "project_name" {
  type = string
}

variable "aws_region" {
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

variable "ecs_instance_type" {
  type = string
}

variable "ecs_ami_id" {
  type = string
}

variable "ecs_instance_profile" {
  type = string
}

########################################
# NETWORKING
########################################

variable "private_subnets" {
  type = list(string)
}

variable "ecs_security_group" {
  type = string
}

########################################
# TASK
########################################

variable "container_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "task_cpu" {
  type = number
}

variable "task_memory" {
  type = number
}

variable "desired_count" {
  type = number
}

########################################
# ALB
########################################

variable "target_group_arn" {
  type = string
}

########################################
# ECR
########################################

variable "ecr_repository_url" {
  type = string
}

########################################
# IAM
########################################

variable "ecs_task_execution_role" {
  type = string
}

variable "key_name" {
  type = string
}

########################################
# CLOUDWATCH
########################################

variable "cloudwatch_log_group" {
  type = string
}

########################################
# SECRETS MANAGER
########################################

variable "secret_arn" {
  type = string
}