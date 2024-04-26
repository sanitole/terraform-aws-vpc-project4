output "lb_dns_name" {
  value = aws_lb.blue-green-deployment.dns_name
}