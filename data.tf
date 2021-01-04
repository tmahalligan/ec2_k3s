data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_ami" "ubuntu_linux" {
  most_recent = true

  owners = var.amiowner

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*",
    ]
  }
}
