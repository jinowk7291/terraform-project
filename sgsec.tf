resource "aws_security_group" "sec-peer" {
  provider = aws.vpc1
  name = "sgpeer1"
  vpc_id = aws_vpc.test.id
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_security_group" "sec-peer2" {
#  provider = aws.vpc2
#  name = "sgpeer2"
#  vpc_id = aws_vpc.v2test.id
#  ingress {
#    cidr_blocks = [ "0.0.0.0/0" ]
#    from_port = 0
#    protocol = "-1"
#    to_port = 0
#  }
#  egress {
#    cidr_blocks = [ "0.0.0.0/0" ]
#    from_port = 0
#    protocol = "-1"
#    to_port = 0
#  }
#  lifecycle {
#    create_before_destroy = true
#  }
#}

# RDS SG
resource "aws_security_group" "sec_rds" {
  name        = "sec_rds"
  description = "Used for RDS"
  vpc_id      = "${aws_vpc.test.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}
# bastion SG
resource "aws_security_group" "sec-bastion" {
  name = "sec-bastion"
  vpc_id = aws_vpc.test.id
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  lifecycle {
    create_before_destroy = true
  }
}
# jenkins SG
resource "aws_security_group" "sec-jenkins" {
  name = "sec-jenkins"
  vpc_id = aws_vpc.test.id
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
  }
  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  lifecycle {
    create_before_destroy = true
  }
}
