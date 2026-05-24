variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}

variable "state_bucket_name" {
  description = "Terraform State Bucket Name"
  type        = string
  default     = "ecs-prod-terraform-state"
}

variable "dynamodb_table_name" {
  description = "Terraform Lock Table"
  type        = string
  default     = "terraform-locks"
}