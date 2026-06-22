variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "terraform_state_bucket" {
  type        = string
  description = "Terraform State Bucket Name"
}

variable "terraform_lock_table" {
  type        = string
  description = "DynamoDB Lock Table Name"
}