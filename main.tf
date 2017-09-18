#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-958128fa
#
# Your subnet ID is:
#
#     subnet-6987b713
#
# Your security group ID is:
#
#     sg-73a74919
#
# Your Identity is:
#
#     terraform-training-duck
#

terraform {
  backend "atlas" {
    name = "marojor/training"
  }
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-central-1"
}

variable "num_web_instances" {
  default = "2"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  count                  = "${var.num_web_instances}"
  ami                    = "ami-958128fa"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-6987b713"
  vpc_security_group_ids = ["sg-73a74919"]

  tags = {
    Identity    = "terraform-training-duck"
    Creator     = "marojor"
    Description = "Terraform training for the people"
    Name        = "web ${count.index + 1}/${var.num_web_instances}"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  # Square brackets are optional
  value = "${aws_instance.web.*.public_dns}"
}

output "name" {
  value = "${aws_instance.web.*.tags.Name}"
}
