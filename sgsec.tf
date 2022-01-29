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
# Bastion SG
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