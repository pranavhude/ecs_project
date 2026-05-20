variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "alb_security_group" {
  type = string
}

variable "container_port" {
  type = number
}

########################################
# HTTPS
########################################

variable "enable_https" {
  type    = bool
  default = false
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}