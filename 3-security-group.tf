module "alb_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> v4.0"
  name        = "alb-security-group"
  description = "http traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "magento_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> v4.0"
  name        = "magento-security-group"
  description = "Allowing ssh and http traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "db_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> v4.0"
  name        = "db-security-group"
  description = "Allowing db traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      source_security_group_id = module.magento_security_group.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}