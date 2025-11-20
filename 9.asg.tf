resource "aws_autoscaling_group" "dev1_asg" {
  name_prefix               = "dev1-auto-scaling-group-"
  min_size                  = 3
  max_size                  = 9
  desired_capacity          = 6
  vpc_zone_identifier       = [aws_subnet.private_1.id, aws_subnet.private_2.id, aws_subnet.private_3.id]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  force_delete              = true

  target_group_arns = [aws_lb_target_group.dev1_tg.arn]

  launch_template {
    id      = aws_launch_template.dev1_lt.id
    version = "$Latest"
  }

  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]

  # Instance protection for launching
  initial_lifecycle_hook {
    name                  = "instance-protection-launch"
    lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
    default_result        = "CONTINUE"
    heartbeat_timeout     = 60
    notification_metadata = "{\"key\":\"value\"}"
  }

  # Instance protection for terminating
  initial_lifecycle_hook {
    name                 = "scale-in-protection"
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 300
  }

  tag {
    key                 = "Name"
    value               = "dev1-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true
  }
}


# Auto Scaling Policy
resource "aws_autoscaling_policy" "dev1_scaling_policy" {
  name                   = "dev1-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.dev1_asg.name

  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 120

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

# Enabling instance scale-in protection
resource "aws_autoscaling_attachment" "dev1_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.dev1_asg.name
  lb_target_group_arn    = aws_lb_target_group.dev1_tg.arn
}