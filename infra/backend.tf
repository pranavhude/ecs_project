terraform {
  backend "s3" {
    bucket         = "ecs-prod-terraform-state-euw1"
    key            = "ecs-ec2-prod/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "ecs-prod-terraform-locks"
  }
}