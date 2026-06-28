variable "project_name" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "execution_role" {
  type = string
}

variable "task_role" {
  type = string
}

variable "secret_arn" {
  type = string
}

variable "ecr_repository" {
  type = string
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecs_security_group_id" {
  type = string
}