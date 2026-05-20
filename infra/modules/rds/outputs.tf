output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "rds_arn" {
  value = aws_db_instance.this.arn
}

output "rds_identifier" {
  value = aws_db_instance.this.identifier
}

output "db_name" {
  value = aws_db_instance.this.db_name
}