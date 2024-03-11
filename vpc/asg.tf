# Create launch template
resource "aws_launch_template" "dev_launch_template" {
  name_prefix   = "dev_launch_template"
  image_id      = var.ami_image
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.webserver_sg.id ]
  key_name = var.key_pair_name
  user_data = filebase64("user-data-apache.sh")
  
  monitoring {
    enabled = true
  }
  
}

# Create auto scaling group


resource "aws_autoscaling_group" "dev_asg" {
  name                      = "dev_asg"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier = [ aws_subnet.Private-subnet-AZ1.id, aws_subnet.Private-subnet-AZ2.id ]
 launch_template {
    name = aws_launch_template.dev_launch_template.name
 }


 tag {
   key = "Name"
   value = "asg-webserver"
   propagate_at_launch = true
 }

 lifecycle {
   ignore_changes = [ target_group_arns ]
 }
}

# Create a new load balancer attachment
 resource "aws_autoscaling_attachment" "asg_alb_target_group_attachment" {
  autoscaling_group_name = aws_autoscaling_group.dev_asg.id
  lb_target_group_arn = aws_lb_target_group.target_group.arn
}