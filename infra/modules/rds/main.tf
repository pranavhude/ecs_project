########################################
# DB SUBNET GROUP
########################################

resource "aws_db_subnet_group" "this" {

  name = "${var.project_name}-db-subnet-group"

  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

########################################
# PARAMETER GROUP
########################################

resource "aws_db_parameter_group" "this" {

  name   = "${var.project_name}-mysql-parameter-group"

  family = "mysql8.0"

  parameter {

    name  = "character_set_server"

    value = "utf8mb4"
  }

  parameter {

    name  = "character_set_client"

    value = "utf8mb4"
  }

  tags = {
    Name = "${var.project_name}-mysql-parameter-group"
  }
}

########################################
# RDS MYSQL INSTANCE
########################################

resource "aws_db_instance" "this" {

  identifier = "${var.project_name}-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = var.db_instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = 100

  storage_type = "gp3"

  storage_encrypted = true

  db_name  = var.db_name

  username = var.db_username

  password = var.db_password

  port = 3306

  multi_az = true

  publicly_accessible = false

  backup_retention_period = 7

  backup_window = "02:00-03:00"

  maintenance_window = "sun:04:00-sun:05:00"

  skip_final_snapshot = true

  deletion_protection = false

  performance_insights_enabled = true

  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  db_subnet_group_name = aws_db_subnet_group.this.name

  parameter_group_name = aws_db_parameter_group.this.name

  vpc_security_group_ids = [
    var.rds_sg_id
  ]

  auto_minor_version_upgrade = true

  tags = {
    Name = "${var.project_name}-mysql"
  }
}