variable "region" {}
variable "key_pair" {}
variable "ami_id" {}
variable "availability_zone" {}

provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "mario21ic.terraform"
    key = "infrav1/terraform.tfstate"
    region = "us-west-2"
  }
  required_version = ">0.9.4"
}


#data "aws_ami" "amazonlinux" {
#  most_recent = true
#  filter {
#    name = "name"
#    values = ["demoami"]
#  }
#  filter {
#    name = "virtualization-type"
#    values = ["hvm"]
#  }
#}

#output "ami_id" {
#  value = "${data.aws_ami.amazonlinux.id}"
#}

module "myvpc" {
  source = "./tfmodules/vpc"
  region = "us-west-2"
  availability_zone = "us-west-2c"
  name = "myvpc"
}
module "myvpc2" {
  source = "./tfmodules/vpc"
  region = "us-east-1"
  availability_zone = "us-east-1b"
  name = "myvpc2"
}
module "myvpc3" {
  source = "./tfmodules/vpc"
  region = "us-west-2"
  availability_zone = "us-west-2a"
  name = "myvpc3"
}

resource "aws_instance" "ec2_demo" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.key_pair}"
  vpc_security_group_ids = ["${aws_security_group.my_sg.id}"]
  subnet_id = "${module.myvpc.subnet_id}"
}

resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "Allow traffic"
  vpc_id      = "${module.myvpc.vpc_id}"

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

