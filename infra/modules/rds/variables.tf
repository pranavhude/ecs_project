variable "project_name" {
  type = string
}

variable "db_name" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "rds_security_group" {
  type = string
}

variable "secret_arn" {
  type = string
}