
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name                 = "training-vpc"
  cidr                 = "10.152.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.152.2.0/24", "10.152.4.0/24", "10.152.6.0/24"]
  enable_dns_hostnames = true

  tags = {
    "Owner" = var.owner
  }

}