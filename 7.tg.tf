resource "aws_lb_target_group" "dev1_tg" {
  name        = "dev1-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.dev1.id
  target_type = "instance"

  health_check {
    enabled             = true
    # interval            = 30
    interval            = 60
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    matcher             = "200"
    # matcher             = "200-399"
  }

  tags = {
    Name = "dev1TargetGroup"
  }
}