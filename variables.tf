variable "region" {
  description = "AWS region"
  type        = string
}
data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

variable "create_instance" {
  description = "EC2 name and type"
  type = list(object({
    ec2_name = string
    ec2_type = string
  }))
}
variable "server_ports" {
  description = "A list of port range"
  type = list(object({
    from_port = number
    to_port   = number
  }))
}
variable "vpc_details" {
  description = "Provide a vpc cidr block"
  type = list(object({
    vpc_cidr             = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
    vpc_name             = string
  }))
}
variable "subnet_cidr" {
  description = "Provide a subnet cidr block"
  type = list(object({
    cidr        = string
    subnet_name = string
    av_zone     = string
  }))
}
variable "ip_on_launch" {
  type    = bool
  default = true
}
variable "key_name" {
  description = "Provide a key name"
  type        = string
}
variable "igw_name" {
  type    = string
  default = ""
}
variable "rt_name" {
  type    = string
  default = ""
}
variable "lb_target_group" {
  description = "Provide a load balancer block"
  type = list(object({
    lb_tg_name     = string
    lb_tg_port     = string
    lb_tg_protocol = string
  }))
}
variable "lb_details" {
  description = "Provide LB block"
  type = list(object({
    lb_name              = string
    lb_listener_port     = string
    lb_listener_protocol = string
  }))
}

variable "enable_blue_env" {
  description = "Enable blue environment"
  type        = bool
  default     = true
}
variable "blue_instance_count" {
  description = "Number of instances in blue environment"
  type        = number
  default     = 2
}
variable "enable_green_env" {
  description = "Enable green environment"
  type        = bool
  default     = false
}
variable "green_instance_count" {
  description = "Number of instances in green environment"
  type        = number
  default     = 2
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
}

locals {
  traffic_dist_map = {
    blue = {
      blue  = 100
      green = 0
    }
    blue-90 = {
      blue  = 90
      green = 10
    }
    split = {
      blue  = 50
      green = 50
    }
    green-90 = {
      blue  = 10
      green = 90
    }
    green = {
      blue  = 0
      green = 100
    }
  }
}

