# autoscaling.tf
resource "aws_launch_template" "app" {
  name_prefix   = "app-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.app-sg-app.id]
 
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app-vm"  
    }
  }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum install -y amazon-efs-utils
    mkdir /mnt/efs
    mount -t efs ${aws_efs_file_system.app.id}:/ /mnt/efs
    echo "${aws_efs_file_system.app.id}:/ /mnt/efs efs defaults,_netdev 0 0" >> /etc/fstab
  EOF
  )
}

resource "aws_autoscaling_group" "app" {
  name                = "app-asg"
  vpc_zone_identifier = aws_subnet.app-private-subnet[*].id
  target_group_arns   = [aws_lb_target_group.app.arn]
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}
