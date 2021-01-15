# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

resource "random_string" "random" {
  length = 4
  special = false
  upper  = false
}

resource "aws_key_pair" "key" {
  key_name   = random_string.random.result
  public_key = file("~/.ssh/${var.owner}.pub")
}


resource "aws_instance" "k3dhost" {
  ami                    = data.aws_ami.ubuntu_linux.id
  instance_type          = var.amitype
  vpc_security_group_ids = [aws_security_group.k3dhost.id]
  key_name               = aws_key_pair.key.key_name
  private_ip             = "10.152.2.50"
  subnet_id              = module.vpc.public_subnets[0]
  user_data              = file("files/k3dhost.sh")
  tags = {
    Name = "k3dhost"
    Owner = format("%s",data.external.whoiamuser.result.iam_user)
  }

  root_block_device {
    volume_size = var.volsize
    encrypted   = true
  }


}




resource "aws_eip" "ip_k3d" {
  vpc      = true
  instance = aws_instance.k3dhost.id 
}

