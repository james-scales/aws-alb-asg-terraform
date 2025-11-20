# Internet Gateway
# Allows resources in public subnets to access the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev1.id
  
  tags = {
    Name = "dev1-igw"
  }
}

# Elastic IP for NAT Gateway
# NAT gateway needs a static public IP address
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  
  tags = {
    Name = "dev1-nat-eip"
  }
  
  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway
# Allows resources in private subnets to reach the internet
# but prevents the internet from initiating connections to them
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id
  
  tags = {
    Name = "dev1-nat-gateway"
  }
  
  depends_on = [aws_internet_gateway.igw]
}