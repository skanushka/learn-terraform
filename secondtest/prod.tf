provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "skanushka-tflearn"
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.prod_tf_course.id
  acl    = "private"
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "allow standard http/https inbound and everything outbound"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0", "1.2.3.4/32"]
  }
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1" # all protocols
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_instance" "prod_web" {
  ami           = "ami-003a61536c01a7373"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_eip" "prod_web" {
  instance = aws_instance.prod_web.id

  tags = {
    "Terraform" : "true"
  }
}