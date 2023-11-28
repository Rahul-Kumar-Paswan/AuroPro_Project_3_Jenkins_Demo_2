output "db_instance_endpoint" {
  value = aws_db_instance.my_db_instance.endpoint
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.my_db_subnet_group.name
}

output "my_rds_sg_id" {
  value = aws_security_group.my_rds_sg.id
}

output "db_username" {
  value = aws_db_instance.my_db_instance.username
}

output "db_password" {
  value = aws_db_instance.my_db_instance.password
}

output "db_database" {
  value = aws_db_instance.my_db_instance.db_name
}