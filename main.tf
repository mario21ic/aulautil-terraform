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

module "ec21" {
  source = "./tfmodules/ec2"
  region = "us-west-2"
  name = "${terraform.workspace}"
  ami_id = "ami-0ad99772"
  key_pair = "demopair"

  vpc_id = "${module.myvpc.vpc_id}"
  subnet_id = "${module.myvpc.subnet_id}"
}
module "ec22" {
  source = "./tfmodules/ec2"
  region = "us-east-1"
  name = "myec22"
  ami_id = "ami-cfe4b2b0"
  key_pair = "virginia_pair"

  vpc_id = "${module.myvpc2.vpc_id}"
  subnet_id = "${module.myvpc2.subnet_id}"
}
module "ec23" {
  source = "./tfmodules/ec2"
  region = "us-west-2"
  name = "myec23"
  ami_id = "ami-0ad99772"
  key_pair = "demopair"

  vpc_id = "${module.myvpc3.vpc_id}"
  subnet_id = "${module.myvpc3.subnet_id}"
}
