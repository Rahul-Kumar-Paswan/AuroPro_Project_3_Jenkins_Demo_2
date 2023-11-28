resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "${var.env_prefix}-db-subnet-group"
  subnet_ids = [
    var.subnet_id_1,
    var.subnet_id_2
  ]
  tags = {
    Name = "${var.env_prefix}-db-subnet-group"
  }
}

resource "aws_db_instance" "my_db_instance" {
  identifier              = var.db_instance_identifier
  allocated_storage       = var.db_allocated_storage
  storage_type            = "gp2"
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  publicly_accessible     = false
  multi_az                = var.db_multi_az
  backup_retention_period = var.db_backup_retention_period
  skip_final_snapshot = true

  vpc_security_group_ids  = [aws_security_group.my_rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.my_db_subnet_group.name  # Use the name attribute of the db subnet group

  parameter_group_name    = "default.mysql5.7"

  final_snapshot_identifier = "my-db-instance-snapshot"  # Replace with your desired final snapshot name

  tags = {
    Name = "${var.env_prefix}-MyDBInstance"
  }
}

resource "aws_security_group" "my_rds_sg" {
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp" 
    security_groups = [var.my_security_group_id] # Reference the EC2 security group ID that allows traffic to RDS
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_prefix}-my-rds-sg"
  }
}

