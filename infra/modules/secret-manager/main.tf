########################################
# RANDOM PASSWORD
########################################

resource "random_password" "db" {

  length  = 16

  special = true
}

########################################
# SECRETS MANAGER SECRET
########################################

resource "aws_secretsmanager_secret" "this" {

  name = "${var.project_name}-db-secret"

  description = "RDS Database Credentials"

  recovery_window_in_days = 7

  tags = {
    Name = "${var.project_name}-db-secret"
  }
}

########################################
# SECRET VERSION
########################################

resource "aws_secretsmanager_secret_version" "this" {

  secret_id = aws_secretsmanager_secret.this.id

  secret_string = jsonencode({

    username = var.db_username

    password = random_password.db.result

    engine   = "mysql"

    host     = var.db_host

    port     = 3306

    dbname   = var.db_name
  })
}