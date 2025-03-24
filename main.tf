provider "aws" {
	region = "us-east-1"
}
resource "aws_vpc" "myvpc" {
  cidr_block = "15.15.0.0/16"
}
resource "aws_subnet" "public" {
  vpc_id = "aws_vpc/myvpc.id"
  cidr_block = "15.15.0.0/24"
  tags = { Name = "public_subnet" }
}
resource "aws_subnet" "private" {
  vpc_id = "aws_vpc.myvpc.id"
  cidr_block = "15.15.1.0/24"
  tags = { Name = "private_subnet" }
}

