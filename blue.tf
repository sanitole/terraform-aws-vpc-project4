resource "aws_instance" "blue" {
  count                  = var.enable_blue_env ? var.blue_instance_count : 0
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.create_instance[0].ec2_type
  subnet_id              = aws_subnet.main2.id
  vpc_security_group_ids = [aws_security_group.group-4.id]
  user_data              = file("blue.sh")
  # {
  #   file_content = "version 1.0 - ${count.index}"
  # })

  tags = {
    Name = var.create_instance[0].ec2_name
  }
}

resource "aws_lb_target_group" "blue" {
  name     = var.lb_target_group[0].lb_tg_name
  port     = var.lb_target_group[0].lb_tg_port
  protocol = var.lb_target_group[0].lb_tg_protocol
  vpc_id   = aws_vpc.group-4.id

  health_check {
    path     = "/health"
    port     = var.lb_target_group[0].lb_tg_port
    protocol = var.lb_target_group[0].lb_tg_protocol
    timeout  = 5
    interval = 10
  }
}
resource "aws_lb_target_group_attachment" "blue" {
  count            = length(aws_instance.blue)
  target_group_arn = aws_lb_target_group.blue.arn
  target_id        = aws_instance.blue[count.index].id
  port             = var.lb_target_group[0].lb_tg_port
  depends_on = [
    aws_lb_target_group.blue,
    aws_instance.blue
  ]
}
# resource "aws_lb_listener" "blue1" {
#   load_balancer_arn = aws_lb.blue-green-deployment.arn
#   port              = var.lb_target_group[0].lb_tg_port
#   protocol          = var.lb_target_group[0].lb_tg_protocol
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.blue.arn
#   }
# }



