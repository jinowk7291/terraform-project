resource "aws_vpc_peering_connection" "vpc_peering" {
  provider = "aws.vpc1"
  peer_vpc_id = "${aws_vpc.v2test.id}"
  vpc_id = "${aws_vpc.test.id}"
  peer_region = "ap-northeast-1"
   
  tags = {
    Name = "VPC Peering VPC1 and VPC2"
  }
}

resource "aws_vpc_peering_connection_accepter" "peering-accepter" {
  provider = "aws.vpc2"
  #provider                  = "aws"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering.id}"
  auto_accept               = true
}
