output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "secret_arn" {
  value = module.secrets_manager.secret_arn
}