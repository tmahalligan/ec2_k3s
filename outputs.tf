output "External_IP" {
  value = aws_eip.ip_k3d.public_ip
}

