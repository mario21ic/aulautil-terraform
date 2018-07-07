provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    Name = "vpc_${var.name}"
    Description = "VPC ${var.name} to delete"
  }
}

resource "aws_subnet" "sn_public_1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.0.1/24"
  availability_zone = "${var.availability_zone}"
}
