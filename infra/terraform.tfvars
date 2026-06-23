aws_region = "ap-south-1"

project_name = "ecs-prod"

vpc_cidr = "10.0.0.0/16"

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

availability_zones = [
  "eu-west-1a",
  "eu-west-1b"
]

ecs_instance_type = "t3.medium"

ecs_desired_capacity = 2
ecs_min_capacity     = 2
ecs_max_capacity     = 4

rds_instance_class = "db.t3.micro"


db_name = "appdb"

db_username = "admin"

domain_name  = "example.com"
app_subdomain = "app"

