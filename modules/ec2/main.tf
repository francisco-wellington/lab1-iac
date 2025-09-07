resource "tls_private_key" "devops_key" {
  algorithm = "RSA"
  rsa_bits  = 2048 
}

resource "aws_key_pair" "devops_key" {
  key_name   = "devops-key"
  public_key = tls_private_key.devops_key.public_key_openssh
}

resource "local_file" "devops_key_pem" {
  filename        = "${path.module}/devops-key.pem"
  content         = tls_private_key.devops_key.private_key_pem
  file_permission = "0400"
}

resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "devops-vpc"
    Iac = true
  }
}

resource "aws_subnet" "devops_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "devops-subnet"
  }
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-sg"
  description = "Permite acesso SSH e HTTP"
  vpc_id      = aws_vpc.devops_vpc.id

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
    from_port   = 3838
    to_port     = 3838
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-sg"
  }
}

resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name = "devops-igw"
  }
}

resource "aws_route_table" "devops_rt" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name = "devops-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.devops_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.devops_igw.id
}

resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.devops_subnet.id
  route_table_id = aws_route_table.devops_rt.id
}


locals {
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y git
    apt-get install -y nodejs
    apt-get install -y npm 
    
    mkdir -p /opt/src
    cd /opt/src
    
    git clone https://github.com/francisco-wellington/node-app
    
    cd node-app
    
    npm install
    
    node index.js
    EOF
}

resource "aws_instance" "devops_instance" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.t3_micro
  key_name               = aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [aws_security_group.devops_sg.id]
  subnet_id              = aws_subnet.devops_subnet.id
  user_data              = local.user_data

  tags = {
    Name = "devops-instance"
    Iac = true
  }
}

