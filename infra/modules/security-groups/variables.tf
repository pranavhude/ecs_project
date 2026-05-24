########################################
# GENERAL
########################################

variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

########################################
# ECS
########################################

variable "container_port" {
  type = number
}

########################################
# OFFICE IP
########################################

variable "office_ip" {
  type = string
}