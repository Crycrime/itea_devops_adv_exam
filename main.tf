provider "aws" {}

resource "aws_vpc" "wordpress_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "wordpress_vpc"
  }
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "allow http"

  dynamic "ingress" {
    for_each = ["80", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress_sg"
  }
}

resource "aws_security_group" "wordpress_db_sg" {
  name        = "wordpress_db_sg"
  description = "allow 3306 port"

  ingress {
    description = "open 3306 port"
    from_port   = 3306
    to_port     = 3306
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
    Name = "wordpress_db_sg"
  }
}

resource "aws_instance" "ec2_wordpress" {
  ami                    = "ami-0e80a462ede03e653" #Amazon Linux 2 AMI (HVM)
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  user_data = templatefile("${path.module}/template/user_data.sh", {
    db_hostname = "${aws_db_instance.wordpress_db.address}",
    db_password = "${var.db_password}",
    db_username = "${var.db_username}"
  })

  depends_on = [aws_db_instance.wordpress_db]

  tags = {
    Name = "Instance with wordpress"
  }
}

resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0.20"
  instance_class         = "db.t2.micro"
  name                   = "wordpress"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.wordpress_db_sg.id]

  tags = {
    Name = "DB for wordpress"
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.ec2_wordpress.id

  tags = {
    Name = "Public IP"
  }
}
