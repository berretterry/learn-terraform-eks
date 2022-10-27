resource "aws_eip" "nat" {
    count = 3

    vpc = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name    = "learn-terraform-eks"
  cidr    = "10.0.0.0/16"
  
  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway  = true
  enable_vpn_gateway  = true

  single_nat_gateway  = false
  reuse_nat_ips       = true
  external_nat_ip_ids = "${aws_eip.nat.*.id}"

  tags = {
    Terraform   = "true"
    Environment = "test"
  }
}

