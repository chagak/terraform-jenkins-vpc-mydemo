# create subnet group
resource "aws_db_subnet_group" "database-group" {
  name       = "database-group"
  subnet_ids = [aws_subnet.Private-subnet-AZ1.id, aws_subnet.Private-subnet-AZ2.id]

  tags = {
    Name = "database-group"
  }
}

# create rds
resource "aws_db_instance" "dev-rds-db-test" {
  allocated_storage    = 10
  db_name              = "applicationdb"
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t2.micro"
  username             = "chaga"
  password             = "chaga123"
  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.database-group.id
  vpc_security_group_ids = [ aws_security_group.database_sg.id ]
  identifier = "dev-rds-db-mydemo"
  publicly_accessible = true

}