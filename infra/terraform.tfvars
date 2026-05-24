########################################
# GENERAL
########################################

project_name = "ecs-prod"

environment = "prod"

aws_region = "ap-south-1"

########################################
# NETWORKING
########################################

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
  "ap-south-1a",
  "ap-south-1b"
]

########################################
# ECS
########################################

ecs_cluster_name = "prod-ecs-cluster"

ecs_service_name = "prod-ecs-service"

container_name = "ecs-app"

container_port = 80

task_cpu = 512

task_memory = 1024

desired_count = 2

aws_region = "ap-south-1"

ecs_instance_type = "t3.medium"

ecs_ami_id = "ami-xxxxxxxx"

key_name = "ecs-key"

########################################
# BASTION
########################################

instance_type = "t3.micro"

key_name = "prod-key"

########################################
# RDS
########################################

db_name = "appdb"

db_username = "admin"

db_password = "ChangeMe123!"

db_instance_class = "db.t3.micro"

allocated_storage = 20