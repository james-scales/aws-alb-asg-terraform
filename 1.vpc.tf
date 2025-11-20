# this  makes  vpc.id which is aws_vpc.app1.id
resource "aws_vpc" "dev1" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "dev1"
  }
}
