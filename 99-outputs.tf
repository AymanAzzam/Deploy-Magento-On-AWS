output "db_admin_password" {
  value = random_password.db_password.result
  sensitive = true
}