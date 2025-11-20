resource "aws_launch_template" "dev1_lt" {
  name_prefix   = "dev1_LT"
  image_id      = "ami-0bddb58ec42d165f9"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web_server.id]

  user_data = filebase64("${path.root}/userdata.sh") 

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "dev1"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
