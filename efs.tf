resource "aws_efs_file_system" "app" {
  creation_token = "app-efs"
    tags = {
    Name = "app-efs"
  }
}

resource "aws_efs_mount_target" "app" {
  count           = 2
  file_system_id  = aws_efs_file_system.app.id
  subnet_id       = aws_subnet.app-private-subnet[count.index].id
  security_groups = [aws_security_group.efs-sg.id]
}
