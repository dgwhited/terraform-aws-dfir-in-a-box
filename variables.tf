variable "vpc_id" {
  type        = string
  description = "Name of the VPC to launch the instance."
}

variable "subnet_id" {
  type        = string
  description = "Name of the subnet to place the instance."
}


variable "aws_tag_name" {
  description = "Desired tag name to use for AWS resources."
  type        = string
}


variable "aws_instance_type" {
  description = "Desired AWS instance type."
  default     = "t3.large"
  type        = string
}

variable "aws_root_block_size" {
  description = "Desired AWS instance root block size."
  default     = 60
  type        = number
}


variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
  type        = string
}
