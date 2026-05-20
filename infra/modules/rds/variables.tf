variable "project_name" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "rds_sg_id" {
  type = string
}

########################################
# DATABASE
########################################

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}