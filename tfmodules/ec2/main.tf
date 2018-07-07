provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "ec2_demo" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.key_pair}"
  vpc_security_group_ids = ["${aws_security_group.my_sg.id}"]
  subnet_id = "${var.subnet_id}"

  count = 3
  tags {
    Name = "${var.name}_${count.index}"
  }
}

resource "aws_security_group" "my_sg" {
  name        = "my_sg_${var.name}"

  description = "Allow traffic"
  vpc_id      = "${var.vpc_id}"

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
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

