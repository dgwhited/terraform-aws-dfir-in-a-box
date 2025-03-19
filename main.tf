data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}


data "aws_subnet" "default" {
  id = var.subnet_id
}


data "aws_vpc" "default" {
  id = var.vpc_id
}


resource "aws_instance" "instance" {
  ami           = var.ami_id != null ? var.ami_id : data.aws_ami.ami.id
  instance_type = var.aws_instance_type
  vpc_security_group_ids = [
    aws_security_group.sg.id,
  ]
  subnet_id                   = data.aws_subnet.default.id
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  associate_public_ip_address = false

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  # root block device settings
  root_block_device {
    volume_size = var.aws_root_block_size
  }
  volume_tags = {
    Name = "dfir-${var.aws_tag_name}"
  }

}


resource "aws_security_group" "sg" {
  name        = "dfir-${var.aws_tag_name}"
  description = "dfir-${var.aws_tag_name}"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
