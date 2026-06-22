output "ecs_instance_role_arn" {
  value = aws_iam_role.ecs_instance_role.arn
}

output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ecs.name
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}