########################################
# VPC MODULE
########################################

module "vpc" {

  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment

  vpc_cidr           = var.vpc_cidr

  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets

  availability_zones = var.availability_zones
}

########################################
# SECURITY GROUP MODULE
########################################

module "security_groups" {

  source = "./modules/security-groups"

  project_name = var.project_name

  vpc_id       = module.vpc.vpc_id
}

########################################
# IAM MODULE
########################################

module "iam" {

  source = "./modules/iam"

  project_name = var.project_name
}

########################################
# ECR MODULE
########################################

module "ecr" {

  source = "./modules/ecr"

  project_name = var.project_name
}

########################################
# CLOUDWATCH MODULE
########################################

module "cloudwatch" {

  source = "./modules/cloudwatch"

  project_name = var.project_name
}

########################################
# SECRETS MANAGER MODULE
########################################

module "secrets_manager" {

  source = "./modules/secrets-manager"

  project_name = var.project_name

  db_username  = var.db_username
  db_password  = var.db_password
}

########################################
# ECS MODULE
########################################

module "ecs" {

  source = "./modules/ecs"

  project_name            = var.project_name

  ecs_cluster_name        = var.ecs_cluster_name
  ecs_service_name        = var.ecs_service_name

  container_name          = var.container_name
  container_port          = var.container_port

  task_cpu                = var.task_cpu
  task_memory             = var.task_memory

  desired_count           = var.desired_count

  private_subnets         = module.vpc.private_subnets

  ecs_security_group      = module.security_groups.ecs_sg_id

  target_group_arn        = module.alb.target_group_arn

  ecs_task_execution_role = module.iam.ecs_task_execution_role_arn

  ecr_repository_url      = module.ecr.repository_url

  cloudwatch_log_group    = module.cloudwatch.log_group_name
}

########################################
# ALB MODULE
########################################

module "alb" {

  source = "./modules/alb"

  project_name       = var.project_name

  vpc_id             = module.vpc.vpc_id

  public_subnets     = module.vpc.public_subnets

  alb_security_group = module.security_groups.alb_sg_id

  container_port     = var.container_port
}

########################################
# BASTION HOST MODULE
########################################

module "bastion" {

  source = "./modules/bastion"

  project_name = var.project_name

  subnet_id    = module.vpc.public_subnets[0]

  instance_type = var.instance_type

  key_name      = var.key_name

  bastion_sg_id = module.security_groups.bastion_sg_id
}

########################################
# RDS MYSQL MODULE
########################################

module "rds" {

  source = "./modules/rds"

  project_name       = var.project_name

  db_name            = var.db_name

  db_username        = var.db_username

  db_password        = var.db_password

  db_instance_class  = var.db_instance_class

  allocated_storage  = var.allocated_storage

  private_subnets    = module.vpc.private_subnets

  rds_sg_id          = module.security_groups.rds_sg_id
}