resource "aws_instance" "green" {
  count                  = var.enable_green_env ? var.green_instance_count : 0
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.create_instance[1].ec2_type
  subnet_id              = aws_subnet.main3.id
  vpc_security_group_ids = [aws_security_group.group-4.id]
  user_data              = file("green.sh")
  #   {
  #   file_content = "version 1.0 - ${count.index}"
  #   })

  tags = {
    Name = var.create_instance[1].ec2_name
  }
}

resource "aws_lb_target_group" "green" {
  name     = var.lb_target_group[1].lb_tg_name
  port     = var.lb_target_group[1].lb_tg_port
  protocol = var.lb_target_group[1].lb_tg_protocol
  vpc_id   = aws_vpc.group-4.id

  health_check {
    path     = "/health"
    port     = var.lb_target_group[1].lb_tg_port
    protocol = var.lb_target_group[1].lb_tg_protocol
    timeout  = 5
    interval = 10
  }
}
resource "aws_lb_target_group_attachment" "green" {
  count            = length(aws_instance.green)
  target_group_arn = aws_lb_target_group.green.arn
  target_id        = aws_instance.green[count.index].id
  port             = var.lb_target_group[1].lb_tg_port
  depends_on = [
    aws_lb_target_group.green,
    aws_instance.green
  ]
}
