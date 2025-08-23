# security_groups.tf
resource "aws_security_group" "alb-sg-alb" {
  name        = "alb-sg-alb"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app-sg-app" {
  name        = "app-sg-app"
  description = "Allow traffic from ALB to app servers"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg-alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "Allow traffic from app servers to database"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app-sg-app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "efs-sg" {
  name        = "efs-sg"
  description = "Allow NFS traffic from app servers to EFS"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
   security_groups = [aws_security_group.app-sg-app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
