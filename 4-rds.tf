resource "aws_db_instance" "magento_rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = var.db_engine_version
  instance_class         = "db.t2.micro"
  port                   = 3306
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [module.db_security_group.security_group_id]
  identifier             = var.db_identifier
  db_name                = var.db_name
  username               = var.db_user
  password               = random_password.db_password.result
  max_allocated_storage  = 100
  skip_final_snapshot    = true
  parameter_group_name   = aws_db_parameter_group.DB_Parameter_Group.name
}
 
resource "aws_db_parameter_group" "DB_Parameter_Group" {
  name   = "magento-parameter-group"
  family = var.parameter_family
 
  parameter {
    name  = "log_bin_trust_function_creators"
    value = 1
  }
}

 
resource "random_password" "db_password" {
  length  = 16
  special = false
  min_lower = 8
  min_upper = 8
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = "db-subnets"
  subnet_ids = module.vpc.private_subnets
}