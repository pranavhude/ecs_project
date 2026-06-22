################################################################################
# ECS Optimized AMI
################################################################################

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

################################################################################
# ECS CLUSTER
################################################################################

resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

################################################################################
# LAUNCH TEMPLATE
################################################################################

resource "aws_launch_template" "this" {

  name_prefix = "${var.project_name}-ecs-"

  image_id = data.aws_ssm_parameter.ecs_ami.value

  instance_type = var.ecs_instance_type

  vpc_security_group_ids = [
    var.ecs_security_group_id
  ]

  iam_instance_profile {
    name = var.ecs_instance_profile
  }

  user_data = base64encode(
    templatefile(
      "${path.module}/userdata.sh.tpl",
      {
        cluster_name = aws_ecs_cluster.this.name
      }
    )
  )

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-ecs-node"
    }
  }

  update_default_version = true
}

################################################################################
# AUTO SCALING GROUP
################################################################################

resource "aws_autoscaling_group" "this" {

  name = "${var.project_name}-ecs-asg"

  desired_capacity = var.desired_capacity
  min_size         = var.min_capacity
  max_size         = var.max_capacity

  vpc_zone_identifier = var.private_subnet_ids

  health_check_type = "EC2"

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ecs-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}