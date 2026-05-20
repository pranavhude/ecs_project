########################################
# ECS TASK EXECUTION ROLE
########################################

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

########################################
# ECS INSTANCE PROFILE
########################################

output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ecs_instance_profile.name
}

########################################
# BASTION INSTANCE PROFILE
########################################

output "bastion_instance_profile" {
  value = aws_iam_instance_profile.bastion_instance_profile.name
}