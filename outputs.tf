output "External_IP" {
  value = aws_spot_instance_request.k3dhost.public_ip
}
