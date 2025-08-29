# aurora.tf
resource "aws_db_subnet_group" "aurora" {
  name       = "aurora-db-subnet-group"
  subnet_ids = aws_subnet.database-private-subnet[*].id
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  database_name           = "mydb"
  master_username         = var.db_username
  master_password         = var.db_password
  vpc_security_group_ids  = [aws_security_group.db-sg.id]
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "aurora" {
  count               = 2
  cluster_identifier  = aws_rds_cluster.aurora.id
  instance_class      = "db.t3.medium"
  engine              = aws_rds_cluster.aurora.engine
}
