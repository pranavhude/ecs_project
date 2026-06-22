output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "rds_address" {
  value = aws_db_instance.this.address
}

output "db_instance_identifier" {
  value = aws_db_instance.this.id
}

output "db_port" {
  value = aws_db_instance.this.port
}