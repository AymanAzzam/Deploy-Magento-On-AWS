# Magento Server Variables

variable "access_key" {
  default = "Enter your key here"
}
 
variable "secret_key" {
  default = "Enter your key here"
}
 
variable "type" {
  default = "t2.micro"
}
 
variable "key_name" {
  default = "magento_key"
}
 
variable "region" {
  default = "us-east-1"
}
 
variable "magento_pem_file_path" {
  default = "keys/magento_key.pem"
}
 
# Magento Deployment Variables

variable "magento_admin_user" {
  default = "admin"
}

variable "magento_admin_password" {
  default = "admin123"
}
 
# RDS Variables
 
variable "db_engine_version" {
  default = "8.0"
}
 
variable "db_identifier" {
  default = "magento-rds"
}
 
variable "parameter_family" {
  default = "mysql8.0"
}

variable "db_name" {
  default = "magento_db"
}

variable "db_user" {
  default = "magento_db_user"
}