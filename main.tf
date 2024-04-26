provider "aws" {
  region = var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")

  tags = {
    Name = var.key_name
    Team = "Group-4"
    Env  = "Dev"
  }
}

resource "aws_vpc" "group-4" {
  cidr_block           = var.vpc_details[0].vpc_cidr
  enable_dns_support   = var.vpc_details[0].enable_dns_support
  enable_dns_hostnames = var.vpc_details[0].enable_dns_hostnames
  instance_tenancy     = "default"

  tags = {
    Name = var.vpc_details[0].vpc_name
  }
}
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.group-4.id
  cidr_block              = var.subnet_cidr[0].cidr
  map_public_ip_on_launch = var.ip_on_launch
  availability_zone       = var.subnet_cidr[0].av_zone

  tags = {
    Name = var.subnet_cidr[0].subnet_name
  }
}
resource "aws_subnet" "main2" {
  vpc_id                  = aws_vpc.group-4.id
  cidr_block              = var.subnet_cidr[1].cidr
  map_public_ip_on_launch = var.ip_on_launch
  availability_zone       = var.subnet_cidr[1].av_zone

  tags = {
    Name = var.subnet_cidr[1].subnet_name
  }
}
resource "aws_subnet" "main3" {
  vpc_id                  = aws_vpc.group-4.id
  cidr_block              = var.subnet_cidr[2].cidr
  map_public_ip_on_launch = var.ip_on_launch
  availability_zone       = var.subnet_cidr[2].av_zone

  tags = {
    Name = var.subnet_cidr[2].subnet_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.group-4.id

  tags = {
    Name = var.igw_name
  }
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.group-4.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.rt_name
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.main2.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.main3.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_lb" "blue-green-deployment" {
  name               = var.lb_details[0].lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.group-4.id]
  subnets = [
    aws_subnet.main.id,
    aws_subnet.main2.id,
    aws_subnet.main3.id
  ]
}

resource "aws_lb_listener" "blue-green-deployment" {
  load_balancer_arn = aws_lb.blue-green-deployment.arn
  port              = var.lb_details[0].lb_listener_port
  protocol          = var.lb_details[0].lb_listener_protocol


  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = lookup(local.traffic_dist_map[var.traffic_distribution], "blue", 100)
      }

      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = lookup(local.traffic_dist_map[var.traffic_distribution], "green", 0)
      }

      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}