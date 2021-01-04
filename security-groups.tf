data "external" "whatismyip" {
  program = ["/bin/bash" , "files/whatismyip.sh"]
}

resource "aws_security_group" "k3dhost" {
  name_prefix = "k3dhost"


  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [format("%s/%s",data.external.whatismyip.result["internet_ip"],32)]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


