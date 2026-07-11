################################################################################
# SECRET LOOKUP
################################################################################

data "aws_secretsmanager_secret_version" "db" {
  secret_id = var.secret_arn
}

locals {
  db_secret = jsondecode(
    data.aws_secretsmanager_secret_version.db.secret_string
  )
}

################################################################################
# DB SUBNET GROUP
################################################################################

resource "aws_db_subnet_group" "this" {
  name = "${var.project_name}-db-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

################################################################################
# MYSQL RDS
################################################################################

resource "aws_db_instance" "this" {

  identifier = "${var.project_name}-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = var.instance_class

  allocated_storage     = 20
  max_allocated_storage = 100

  storage_type      = "gp3"
  storage_encrypted = true

  username = local.db_secret.username
  password = local.db_secret.password

  db_name = var.db_name

  port = 3306

  multi_az = true

  publicly_accessible = false

  deletion_protection = false

  skip_final_snapshot = false
  final_snapshot_identifier = "${var.project_name}-final-snapshot"

  backup_retention_period = 7
  backup_window           = "01:00-02:00"

  maintenance_window = "sun:03:00-sun:04:00"

  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [
    var.rds_security_group
  ]

  auto_minor_version_upgrade = true

  apply_immediately = false

  performance_insights_enabled = false

  tags = {
    Name = "${var.project_name}-mysql"
  }
}