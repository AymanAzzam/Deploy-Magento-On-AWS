output "db_endpoint" {
  value = aws_db_instance.magento_rds.address
}

output "db_name" {
  value = aws_db_instance.magento_rds.db_name
}

output "db_username" {
  value = aws_db_instance.magento_rds.username
}

output "db_password" {
  value = random_password.db_password.result
  sensitive = true
}