variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "ecs_instance_type" {
  type = string
}

variable "ecs_desired_capacity" {
  type = number
}

variable "ecs_min_capacity" {
  type = number
}

variable "ecs_max_capacity" {
  type = number
}

variable "rds_instance_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "app_subdomain" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "app_subdomain" {
  type = string
}