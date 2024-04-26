# HW-terraform

## Create blue/green deployment using module block in main.tf:

```hcl

module "vpc" {
  source = "sanitole/vpc-project4/aws"
  region   = "us-east-2"
  key_name = "Bastion-key"
  create_instance = [
    { ec2_name = "blue-group-4", ec2_type = "t2.micro" },
    { ec2_name = "green-group-4", ec2_type = "t2.micro" }
  ]
  vpc_details = [{
    vpc_cidr             = "10.0.0.0/16",
    enable_dns_support   = true,
    enable_dns_hostnames = true,
    vpc_name = "group-4"
  }]
  ip_on_launch = true
  subnet_cidr = [
    { cidr = "10.0.1.0/24", subnet_name = "group4_subnet1", av_zone = "us-east-2a" },
    { cidr = "10.0.2.0/24", subnet_name = "group4_subnet2", av_zone = "us-east-2b" },
    { cidr = "10.0.3.0/24", subnet_name = "group4_subnet3", av_zone = "us-east-2c" }
  ]
  server_ports = [
    { from_port = 22, to_port = 22 },
    { from_port = 80, to_port = 80 },
    { from_port = 443, to_port = 443 }  # Provide list of ports             
  ]
  igw_name = "group-4-igw"
  rt_name  = "group-4-rt"
  lb_details = [{
    lb_name = "blue-green-deployment",
    lb_listener_port = "80",
    lb_listener_protocol = "HTTP"  
  }]
  lb_target_group = [
    { lb_tg_name = "blue-tg-lb", lb_tg_port = "80", lb_tg_protocol = "HTTP" },
    { lb_tg_name = "green-tg-lb", lb_tg_port = "80", lb_tg_protocol = "HTTP" }
  ]
  enable_blue_env = true
  enable_green_env = false
  Gtraffic_distribution = "split"   # Provide traffic distribution
}
```

## Create EC2 instances for blue and green deployment (blue.tf, green.tf), two for each to make it highly available. And input user data for each instance creating blue.sh and green.sh files.

```hcl
# for blue

#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo '<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <style>
        body { background-color: #0000FF; } /* Sets background to blue */
        h1 { color: white; text-align: center; }
        p { color: white; text-align: center; }
    </style>
</head>
<body>
    <h1>Welcome to the Blue Server!</h1>
    <p>This is a blue-themed page served from $(hostname -f).</p>
</body>
</html>' | sudo tee /var/www/html/index.html > /dev/null
```

```hcl
#for green

#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo '<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <style>
        body { background-color: #00FF00; } /* Sets background to green */
        h1 { color: white; text-align: center; }
        p { color: white; text-align: center; }
    </style>
</head>
<body>
    <h1>Welcome to the Green Server!</h1>
    <p>This is a green-themed page served from $(hostname -f).</p>
</body>
</html>' | sudo tee /var/www/html/index.html > /dev/null
```
## Manually create S3 bucket with unique name "any_name" and store your state file in a remote backend, you can also lock your state file by using DynamoDB table.

```hcl
terraform {
  backend "s3" {
    bucket = "group-4-project"
    key    = "ohio/terraform.tfstate"
    region = "us-east-2"
    #dynamodb_table = "lock-state"
  }
}
```