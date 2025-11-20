resource "aws_security_group" "web_server" {
  name        = "web_server"
  description = "Allow HTTP and SSH for web server"
  vpc_id      = aws_vpc.dev1.id

  tags = {
    Name = "web-server-ingress"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web_server.id

  referenced_security_group_id = aws_security_group.load_balancer.id
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.web_server.id
  cidr_ipv4         = "10.10.0.0/16"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.web_server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

###################################

resource "aws_security_group" "load_balancer" {
  name        = "load_balancer"
  description = "Allow HTTP for load balancer"
  vpc_id      = aws_vpc.dev1.id

  tags = {
    Name = "load-balancer-ingress"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http1" {
  security_group_id = aws_security_group.load_balancer.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "egress1" {
  security_group_id = aws_security_group.load_balancer.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}