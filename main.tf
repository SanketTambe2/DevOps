Provider "aws" {
	region = "us-east-1"
}
Resource "aws_vpc" "myvpc" {
  cidr_block = "10.10.0.0/16"
}
