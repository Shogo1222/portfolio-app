resource "aws_db_instance" "bischierge-rds" {
  allocated_storage         = 20
  storage_type              = "gp2"
  engine                    = "mysql"
  engine_version            = "5.7.30"
  instance_class            = "db.t2.micro"
  name                      = "production"
  username                  = var.aws_db_user
  password                  = var.aws_db_password
  port                      = 3306
  vpc_security_group_ids    = [aws_security_group.bischierge-rds-security-group.id]
  db_subnet_group_name      = aws_db_subnet_group.bischierge-rds-subnet-group.name
  multi_az                  = false
  backup_retention_period   = 7
  skip_final_snapshot = true
}

variable "aws_db_user" {}
variable "aws_db_password" {}
