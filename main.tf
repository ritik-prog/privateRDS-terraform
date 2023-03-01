# Define the Region
provider "aws" {
  region = "us-east-1"
}

# Define the VPC
resource "aws_vpc" "private_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Define the private subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.private_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.private_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

# Define the security group for the RDS instance
resource "aws_security_group" "private_db_sg" {
  name_prefix = "private-db-sg-"
  vpc_id      = aws_vpc.private_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.private_subnet_1.cidr_block, aws_subnet.private_subnet_2.cidr_block]
  }
}

# Define the RDS instance
resource "aws_db_instance" "private_db_instance" {
  identifier             = "private-db-instance"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  allocated_storage      = 10
  storage_type           = "gp2"
  db_subnet_group_name   = "private-db-subnet-group"
  vpc_security_group_ids = [aws_security_group.private_db_sg.id]
  availability_zone      = "us-east-1a"
  username               = "ritik"
  password               = "ritik1234"
}

# Define the subnet group for the RDS instance
resource "aws_db_subnet_group" "private_db_subnet_group" {
  name       = "private-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}
