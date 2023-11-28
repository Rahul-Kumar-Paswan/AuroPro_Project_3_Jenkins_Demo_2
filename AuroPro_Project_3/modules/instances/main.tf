resource "tls_private_key" "ssh_private_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "my-key-pair"
  public_key = tls_private_key.ssh_private_key.public_key_openssh
}

resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.latest-amazon-image.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.ssh_key.key_name  # Associate the key pair with the instance
  tags = {
    Name = var.instance_name
  }
  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]

  associate_public_ip_address = true

  user_data = file("entry-script.sh")

}

data "aws_ami" "latest-amazon-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "my_security_group" {
  name_prefix   = "${var.env_prefix}-security-group"
  description   = "Allow traffic on specified ports"
  vpc_id        = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }


  ingress {
    from_port   = 2375
    to_port     = 2375
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with the appropriate IP range for your MySQL server
  }

  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

  tags = {
    Name = "${var.env_prefix}-security-group"
  }
}
