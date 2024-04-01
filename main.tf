

resource "aws_security_group" "ec2_security_group" {
  name        = "ec2-security-group"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing SSH access from anywhere (0.0.0.0/0)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing HTTP access from anywhere (0.0.0.0/0)
  }

    # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "public_instance" {
  ami                         = "ami-007020fd9c84e18c7" # Replace with your AMI ID
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  security_groups             = [aws_security_group.ec2_security_group.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet.id



  tags = {
    Name = "Public Instance"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
}

resource "aws_instance" "private_instance" {
  ami                         = "ami-007020fd9c84e18c7" # Replace with your AMI ID
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  security_groups             = [aws_security_group.ec2_security_group.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.private_subnet.id

  tags = {
    Name = "Private Instance"
  }
}