module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v4.0"

  name                     = "magento-vpc"
  cidr                     = "10.0.0.0/24"
  azs                      = ["${var.region}a","${var.region}b"]
  public_subnets           = ["10.0.0.0/28", "10.0.0.16/28"]
  private_subnets          = ["10.0.0.32/28", "10.0.0.48/28"]
  map_public_ip_on_launch  = true
  enable_nat_gateway       = true
  single_nat_gateway       = false
  one_nat_gateway_per_az   = true
}