########################################
# GENERAL
########################################

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "environment" {
  type        = string
  description = "Environment Name"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

########################################
# NETWORKING
########################################

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Block"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public Subnet CIDRs"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private Subnet CIDRs"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
}

########################################
# ECS
########################################

variable "ecs_cluster_name" {
  type        = string
  description = "ECS Cluster Name"
}

variable "ecs_service_name" {
  type        = string
  description = "ECS Service Name"
}

variable "container_name" {
  type        = string
  description = "Container Name"
}

variable "container_port" {
  type        = number
  description = "Container Port"
}

variable "task_cpu" {
  type        = number
  description = "ECS Task CPU"
}

variable "task_memory" {
  type        = number
  description = "ECS Task Memory"
}

variable "desired_count" {
  type        = number
  description = "Desired ECS Task Count"
}
variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "ecs_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "ecs_ami_id" {
  type = string
}

variable "key_name" {
  type = string
}
########################################
# EC2 BASTION
########################################

variable "instance_type" {
  type        = string
  description = "Bastion EC2 Instance Type"
}

variable "key_name" {
  type        = string
  description = "SSH Key Pair Name"
}

########################################
# RDS
########################################

variable "db_name" {
  type        = string
  description = "Database Name"
}

variable "db_username" {
  type        = string
  description = "Database Username"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database Password"
}

variable "db_instance_class" {
  type        = string
  description = "RDS Instance Class"
}

variable "allocated_storage" {
  type        = number
  description = "RDS Allocated Storage"
}