# Load Balancer Resources
resource "aws_lb" "dev1_alb" {
  name                       = "dev1-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.load_balancer.id]
  subnets                    = [aws_subnet.public_1.id, aws_subnet.public_2.id, aws_subnet.public_3.id]
  enable_deletion_protection = false
  #Lots of death and suffering here, make sure it's false

  tags = {
    Name = "dev1LoadBalancer"
  }
}

resource "aws_lb_listener" "http1" {
  load_balancer_arn = aws_lb.dev1_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev1_tg.arn
  }
}