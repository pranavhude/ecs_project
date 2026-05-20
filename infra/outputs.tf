########################################
# VPC
########################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

########################################
# SUBNETS
########################################

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

########################################
# ALB
########################################

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

########################################
# ECS
########################################

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

########################################
# ECR
########################################

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

########################################
# RDS
########################################

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

########################################
# BASTION
########################################

output "bastion_public_ip" {
  value = module.bastion.public_ip
}