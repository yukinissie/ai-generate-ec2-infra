provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "ai_generate_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "ai_generate_subnet" {
  vpc_id     = aws_vpc.ai_generate_vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "ai_generate_igw" {
  vpc_id = aws_vpc.ai_generate_vpc.id
}

resource "aws_route_table" "ai_generate_route_table" {
  vpc_id = aws_vpc.ai_generate_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ai_generate_igw.id
  }
}

resource "aws_route_table_association" "ai_generate_route_table_association" {
  subnet_id      = aws_subnet.ai_generate_subnet.id
  route_table_id = aws_route_table.ai_generate_route_table.id
}

resource "aws_security_group" "ai_generate_sg" {
  name        = "ai_generate_sg"
  description = "Security group for AI Generate EC2 instance"
  vpc_id      = aws_vpc.ai_generate_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_instance" "ai_generate_ec2" {
  ami                    = "ami-0d52744d6551d851e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.ai_generate_subnet.id
  key_name               = "your_key_name"
  vpc_security_group_ids = [aws_security_group.ai_generate_sg.id]

  tags = {
    Name = "AI Generate EC2"
  }
}

resource "aws_eip" "ai_generate_eip" {
  instance = aws_instance.ai_generate_ec2.id
}

