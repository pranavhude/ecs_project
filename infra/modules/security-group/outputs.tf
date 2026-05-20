########################################
# ALB SG
########################################

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

########################################
# ECS SG
########################################

output "ecs_sg_id" {
  value = aws_security_group.ecs.id
}

########################################
# RDS SG
########################################

output "rds_sg_id" {
  value = aws_security_group.rds.id
}

########################################
# BASTION SG
########################################

output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}