#######################
# Front Security Group
#######################
resource "aws_security_group" "bischierge-front-security-group" {
  name        = "bischierge-front-security-group"
  description = "bischierge-front-security-group"
  vpc_id      = aws_vpc.bischierge-vpc.id

  ingress {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      ipv6_cidr_blocks     = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#######################
# Back Security Group
#######################
resource "aws_security_group" "bischierge-back-security-group" {
  name        = "bischierge-back-security-group"
  description = "bischierge-back-security-group"
  vpc_id      = aws_vpc.bischierge-vpc.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.bischierge-front-security-group.id]
    self            = false
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.bischierge-front-security-group.id]
    self            = false
  }
  
}

#######################
# RDS Security Group
#######################
resource "aws_security_group" "bischierge-rds-security-group" {
  name        = "bischierge-rds-security-group"
  description = "bischierge-rds-security-group"
  vpc_id      = aws_vpc.bischierge-vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bischierge-back-security-group.id]
    self            = false
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
