terraform {

  backend "s3" {

    bucket         = "ecs-prod-terraform-state"
    key            = "ecs-app/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}