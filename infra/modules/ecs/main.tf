########################################
# ECS CLUSTER
########################################

resource "aws_ecs_cluster" "this" {

  name = var.ecs_cluster_name

  setting {

    name  = "containerInsights"

    value = "enabled"
  }

  tags = {
    Name = var.ecs_cluster_name
  }
}

########################################
# ECS LAUNCH TEMPLATE
########################################

resource "aws_launch_template" "ecs" {

  name_prefix = "${var.project_name}-ecs-template"

  image_id = var.ecs_ami_id

  instance_type = var.ecs_instance_type

  key_name = var.key_name

  iam_instance_profile {

    name = var.ecs_instance_profile
  }

  vpc_security_group_ids = [
    var.ecs_security_group
  ]

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
EOF
  )

  block_device_mappings {

    device_name = "/dev/xvda"

    ebs {

      volume_size = 30

      volume_type = "gp3"

      encrypted = true
    }
  }

  monitoring {
    enabled = true
  }

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-ecs-instance"
    }
  }
}

########################################
# AUTO SCALING GROUP
########################################

resource "aws_autoscaling_group" "ecs" {

  name = "${var.project_name}-ecs-asg"

  desired_capacity = 2

  min_size = 1

  max_size = 4

  vpc_zone_identifier = var.private_subnets

  health_check_type = "EC2"

  launch_template {

    id = aws_launch_template.ecs.id

    version = "$Latest"
  }

  tag {

    key = "Name"

    value = "${var.project_name}-ecs-node"

    propagate_at_launch = true
  }
}

########################################
# ECS CAPACITY PROVIDER
########################################

resource "aws_ecs_capacity_provider" "this" {

  name = "${var.project_name}-capacity-provider"

  auto_scaling_group_provider {

    auto_scaling_group_arn = aws_autoscaling_group.ecs.arn

    managed_scaling {

      status = "ENABLED"

      target_capacity = 80

      minimum_scaling_step_size = 1

      maximum_scaling_step_size = 2
    }
  }
}

########################################
# ATTACH CAPACITY PROVIDER
########################################

resource "aws_ecs_cluster_capacity_providers" "this" {

  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [
    aws_ecs_capacity_provider.this.name
  ]

  default_capacity_provider_strategy {

    capacity_provider = aws_ecs_capacity_provider.this.name

    weight = 1
  }
}

########################################
# ECS TASK DEFINITION
########################################

resource "aws_ecs_task_definition" "app" {

  family = "${var.project_name}-task"

  network_mode = "bridge"

  requires_compatibilities = [
    "EC2"
  ]

  cpu = var.task_cpu

  memory = var.task_memory

  execution_role_arn = var.ecs_task_execution_role

  container_definitions = jsonencode([

    {

      name = var.container_name

      image = "${var.ecr_repository_url}:latest"

      essential = true

      memory = var.task_memory

      cpu = var.task_cpu

      portMappings = [

        {
          containerPort = var.container_port

          hostPort = var.container_port

          protocol = "tcp"
        }
      ]

      environment = [

        {
          name = "ENV"

          value = "production"
        }
      ]

      secrets = [

        {
          name = "DB_SECRET"

          valueFrom = var.secret_arn
        }
      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = var.cloudwatch_log_group

          awslogs-region = var.aws_region

          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-task-definition"
  }
}

########################################
# ECS SERVICE
########################################

resource "aws_ecs_service" "this" {

  name = var.ecs_service_name

  cluster = aws_ecs_cluster.this.id

  task_definition = aws_ecs_task_definition.app.arn

  desired_count = var.desired_count

  launch_type = "EC2"

  deployment_minimum_healthy_percent = 50

  deployment_maximum_percent = 200

  enable_ecs_managed_tags = true

  health_check_grace_period_seconds = 60

  load_balancer {

    target_group_arn = var.target_group_arn

    container_name = var.container_name

    container_port = var.container_port
  }

  depends_on = [
    aws_ecs_cluster_capacity_providers.this
  ]

  tags = {
    Name = "${var.project_name}-ecs-service"
  }
}