variable "service_linked_role_for_auto_scaling_ecs" {}
variable "ami_id" {}
variable "key_pair" {}
variable "ecs_role" {}

#######################
# Auto Scaling Group
#######################
resource "aws_autoscaling_group" "bischierge-auto-scaling-group-v3" {
  default_cooldown          = "300"
  desired_capacity          = "1"
  force_delete              = "false"
  health_check_grace_period = "300"
  health_check_type         = "EC2"
  launch_configuration      = aws_launch_configuration.bischierge-launch-config-ecs.name
  max_instance_lifetime     = "0"
  max_size                  = "1"
  metrics_granularity       = "1Minute"
  min_size                  = "0"
  name                      = "bischierge-auto-scaling-group-v3"
  protect_from_scale_in     = "false"
  service_linked_role_arn   = var.service_linked_role_for_auto_scaling_ecs

  tag {
    key                 = "Description"
    propagate_at_launch = "true"
    value               = "This instance is the part of the Auto Scaling group which was created through ECS Console\t"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = "true"
    value               = "ECS Instance - EC2ContainerService-bischierge-cluster"
  }

  vpc_zone_identifier       = [aws_subnet.subnet-bischierge-front-subnet-1c.id, aws_subnet.subnet-bischierge-front-subnet-1a.id]
  wait_for_capacity_timeout = "10m"
}

#######################
# Launch Configrations
#######################
resource "aws_launch_configuration" "bischierge-launch-config-ecs" {
  associate_public_ip_address = "true"
  ebs_optimized               = "false"
  enable_monitoring           = "false"
  iam_instance_profile        = var.ecs_role
  image_id                    = var.ami_id
  instance_type               = "t3.small"
  key_name                    = var.key_pair
  name                        = "bischierge-launch-config-ecs"

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    iops                  = "0"
    volume_size           = "30"
    volume_type           = "gp2"
  }

  security_groups  = [aws_security_group.bischierge-front-security-group.id]
  user_data = file("user_data.sh")
}
