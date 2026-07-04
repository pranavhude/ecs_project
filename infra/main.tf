module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
}

module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
}

module "secrets_manager" {
  source = "./modules/secrets-manager"

  project_name = var.project_name

  db_username = var.db_username
  db_name     = var.db_name
  # db_host     = module.rds.rds_address
}

module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  db_name            = var.db_name
  instance_class     = var.rds_instance_class

  private_subnet_ids = module.vpc.private_subnet_ids

  rds_security_group = module.security_groups.rds_sg_id

  secret_arn         = module.secrets_manager.secret_arn
}

module "alb" {
  source = "./modules/alb"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id

  public_subnet_ids  = module.vpc.public_subnet_ids

  alb_security_group = module.security_groups.alb_sg_id
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  project_name = var.project_name

  ecs_instance_type = var.ecs_instance_type

  desired_capacity = var.ecs_desired_capacity
  min_capacity     = var.ecs_min_capacity
  max_capacity     = var.ecs_max_capacity

  private_subnet_ids = module.vpc.private_subnet_ids

  ecs_security_group_id = module.security_groups.ecs_sg_id

  ecs_instance_profile = module.iam.ecs_instance_profile
}

module "ecs_capacity_provider" {
  source = "./modules/ecs-capacity-provider"

  cluster_name = module.ecs_cluster.cluster_name
  asg_arn      = module.ecs_cluster.asg_arn
}

module "ecs_service" {
  source = "./modules/ecs-service"

  project_name          = var.project_name
  cluster_id            = module.ecs_cluster.cluster_id
  target_group_arn      = module.alb.target_group_arn
  execution_role        = module.iam.ecs_task_execution_role_arn
  task_role             = module.iam.ecs_task_role_arn
  secret_arn            = module.secrets_manager.secret_arn
  ecr_repository        = module.ecr.repository_url

  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.security_groups.ecs_sg_id
}

module "bastion" {

  source = "./modules/bastion"

  project_name = var.project_name

  public_subnet_id = module.vpc.public_subnet_ids[0]

  bastion_security_group = module.security_groups.bastion_sg_id
}

module "cloudwatch" {

  source = "./modules/cloudwatch"

  project_name = var.project_name

  cluster_name = module.ecs_cluster.cluster_name

  service_name = module.ecs_service.service_name

  rds_id = module.rds.db_instance_identifier

  alb_arn_suffix = module.alb.alb_arn_suffix

  target_group_arn_suffix = module.alb.target_group_arn_suffix
}

# module "route53" {
#   source = "./modules/route53"

#   domain_name = var.domain_name
#   subdomain   = var.app_subdomain
#   alb_dns_name = module.alb.alb_dns_name
#   alb_zone_id  = module.alb.alb_zone_id
# }