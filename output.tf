output "bastion-ip" {
  value = aws_instance.my-ec2-bastion.public_ip
}

output "private-subnet-a" {
  value = aws_subnet.private-subnet-a.id
}
