########################################
# ALB SECURITY GROUP
########################################

resource "aws_security_group" "alb" {

  name = "${var.project_name}-alb-sg"

  description = "ALB Security Group"

  vpc_id = var.vpc_id

  ########################################
  # HTTP
  ########################################

  ingress {

    description = "HTTP Access"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ########################################
  # HTTPS
  ########################################

  ingress {

    description = "HTTPS Access"

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ########################################
  # OUTBOUND
  ########################################

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

########################################
# ECS SECURITY GROUP
########################################

resource "aws_security_group" "ecs" {

  name = "${var.project_name}-ecs-sg"

  description = "ECS Security Group"

  vpc_id = var.vpc_id

  ########################################
  # ALLOW TRAFFIC FROM ALB
  ########################################

  ingress {

    description = "Traffic From ALB"

    from_port = var.container_port

    to_port = var.container_port

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  ########################################
  # OUTBOUND
  ########################################

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-ecs-sg"
  }
}

########################################
# RDS SECURITY GROUP
########################################

resource "aws_security_group" "rds" {

  name = "${var.project_name}-rds-sg"

  description = "RDS Security Group"

  vpc_id = var.vpc_id

  ########################################
  # MYSQL ACCESS FROM ECS
  ########################################

  ingress {

    description = "MySQL Access From ECS"

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    security_groups = [
      aws_security_group.ecs.id
    ]
  }

  ########################################
  # MYSQL ACCESS FROM BASTION
  ########################################

  ingress {

    description = "MySQL Access From Bastion"

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    security_groups = [
      aws_security_group.bastion.id
    ]
  }

  ########################################
  # OUTBOUND
  ########################################

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

########################################
# BASTION SECURITY GROUP
########################################

resource "aws_security_group" "bastion" {

  name = "${var.project_name}-bastion-sg"

  description = "Bastion Security Group"

  vpc_id = var.vpc_id

  ########################################
  # SSH ACCESS
  ########################################

  ingress {

    description = "SSH Access"

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = [
      var.office_ip
    ]
  }

  ########################################
  # OUTBOUND
  ########################################

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}