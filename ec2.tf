data "aws_ami" "amazonLinux" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-2.0.*" ]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }

  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

resource "aws_instance" "bastion" {
  ami = data.aws_ami.amazonLinux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.sec-bastion.id
   ]
  subnet_id = aws_subnet.publicSubnet1.id
  key_name = "mysoldesktestkey"
  associate_public_ip_address = "true" 
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    tags = {
      "Name" = "bation-public-ec2-01-vloume-1"
    }
  }
  tags = {
    "Name" = "bastion-public-ec2-01"
  }
}

resource "aws_instance" "jenkinsserver" {
  ami = data.aws_ami.amazonLinux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.sec-jenkins.id
   ]
  subnet_id = aws_subnet.publicSubnet1.id
  key_name = "mysoldesktestkey"
  associate_public_ip_address = "true" 
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    tags = {
      "Name" = "jenkins-public-ec2-02-vloume-2"
    }
  }
  user_data = "${file("install_jenkins.sh")}"
  tags = {
    "Name" = "jenkins-public-ec2-02"
  }
}
