########################################
# ECS TASK EXECUTION ROLE
########################################

resource "aws_iam_role" "ecs_task_execution_role" {

  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ecs-task-execution-role"
  }
}

########################################
# ECS TASK EXECUTION POLICY ATTACHMENT
########################################

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {

  role = aws_iam_role.ecs_task_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

########################################
# CUSTOM SECRETS MANAGER POLICY
########################################

resource "aws_iam_policy" "secrets_manager_policy" {

  name = "${var.project_name}-secrets-manager-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = "*"
      }
    ]
  })
}

########################################
# ATTACH SECRETS POLICY TO ECS ROLE
########################################

resource "aws_iam_role_policy_attachment" "secrets_attach" {

  role = aws_iam_role.ecs_task_execution_role.name

  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

########################################
# ECS EC2 INSTANCE ROLE
########################################

resource "aws_iam_role" "ecs_instance_role" {

  name = "${var.project_name}-ecs-instance-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

########################################
# ECS EC2 INSTANCE PROFILE
########################################

resource "aws_iam_instance_profile" "ecs_instance_profile" {

  name = "${var.project_name}-ecs-instance-profile"

  role = aws_iam_role.ecs_instance_role.name
}

########################################
# ECS EC2 POLICY ATTACHMENT
########################################

resource "aws_iam_role_policy_attachment" "ecs_instance_attach" {

  role = aws_iam_role.ecs_instance_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

########################################
# CLOUDWATCH AGENT POLICY
########################################

resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {

  role = aws_iam_role.ecs_instance_role.name

  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

########################################
# SSM POLICY
########################################

resource "aws_iam_role_policy_attachment" "ssm_attach" {

  role = aws_iam_role.ecs_instance_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

########################################
# BASTION IAM ROLE
########################################

resource "aws_iam_role" "bastion_role" {

  name = "${var.project_name}-bastion-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

########################################
# BASTION INSTANCE PROFILE
########################################

resource "aws_iam_instance_profile" "bastion_instance_profile" {

  name = "${var.project_name}-bastion-instance-profile"

  role = aws_iam_role.bastion_role.name
}

########################################
# BASTION SSM ACCESS
########################################

resource "aws_iam_role_policy_attachment" "bastion_ssm_attach" {

  role = aws_iam_role.bastion_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}