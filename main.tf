# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "key" {
  key_name   = var.owner
  public_key = file("~/.ssh/${var.owner}.pub")
}


resource "aws_spot_instance_request" "k3dhost" {
  ami                    = data.aws_ami.ubuntu_linux.id
  instance_type          = var.amitype
  spot_price             = var.spotprice
  vpc_security_group_ids = [aws_security_group.k3dhost.id]
  key_name               = var.owner
  user_data              = file("files/k3dhost.sh")
  tags = {
    Name = "k3dhost"
    Owner = var.owner
  }

  root_block_device {
    volume_size = var.volsize
    encrypted   = true
  }


}


#resource "aws_eip" "ip" {
#  vpc      = true
#  instance = aws_instance.k3dhost.id
#  associate_with_private_ip = "10.152.2.50" 
#}

