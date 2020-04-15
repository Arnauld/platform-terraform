output "bastion-ip" {
  value = aws_instance.my-ec2-bastion.public_ip
}
