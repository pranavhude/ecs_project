################################################################################
# CAPACITY PROVIDER
################################################################################

resource "aws_ecs_capacity_provider" "this" {
  name = "cp-${var.cluster_name}"

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.asg_arn

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 10
    }

    managed_termination_protection = "DISABLED"
  }
}

################################################################################
# CLUSTER CAPACITY PROVIDER
################################################################################

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = var.cluster_name

  capacity_providers = [
    aws_ecs_capacity_provider.this.name
  ]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name

    weight = 100
    base   = 1
  }
}