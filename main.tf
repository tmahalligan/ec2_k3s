# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}


resource "aws_key_pair" "tomtest" {
  key_name   = "tomtest"
  public_key = file("~/.ssh/tommy.pem.pub")
}

resource "aws_iam_role" "k3dhost" {
  name = "k3dhost"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}


resource "aws_iam_instance_profile" "k3dhost_profile" {
  name = "k3dhost"
  role = aws_iam_role.k3dhost.name
}

resource "aws_iam_role_policy" "k3dhost_policy" {
  name   = "k3d_policy"
  role   = aws_iam_role.k3dhost.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_instance" "k3dhost" {
  ami                    = data.aws_ami.ubuntu_linux.id
  instance_type          = "t3a.xlarge"
  vpc_security_group_ids = [aws_security_group.k3dhost.id]
  iam_instance_profile   = aws_iam_instance_profile.k3dhost_profile.name
  key_name               = "tomtest"
  user_data              = file("files/k3dhost.sh")
  tags = {
    Name = "k3dhost"
  }

  root_block_device {
    volume_size = 50
    encrypted   = true
  }


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/tommy.pem")
    host        = self.public_ip
  }

}


resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.k3dhost.id 
}

