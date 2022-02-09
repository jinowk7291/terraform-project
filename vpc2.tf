resource "aws_vpc" "v2test" {
  provider = aws.vpc2
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
 
  tags = {
    "Name" = "terraform-v2test-vpc"
  }
}

resource "aws_subnet" "v2publicSubnet1" {
  provider = aws.vpc2
  vpc_id = aws_vpc.v2test.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"
  tags = {
    "Name" = "v2test-public-subnet-01"
    "kubernetes.io/cluster/terraformEKScluster" = "shared"
    "kubernetes.io/role/elb" = 1
    
  }
}

resource "aws_subnet" "v2privateSubnet1" {
  provider = aws.vpc2
  vpc_id = aws_vpc.v2test.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    "Name" = "v2test-private-subnet-01"
  }
}

resource "aws_subnet" "v2privateSubnet2" {
  provider = aws.vpc2
  vpc_id = aws_vpc.v2test.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-1d"
  tags = {
    "Name" = "v2test-private-subnet-02"
  }
}


resource "aws_internet_gateway" "v2testIGW" {
  provider = aws.vpc2
  vpc_id = aws_vpc.v2test.id
  tags = {
    "Name" = "v2testIGW"
  }
}

resource "aws_eip" "v2nateip" {
  provider = aws.vpc2
  vpc = true
}

resource "aws_nat_gateway" "v2tf-natgw" {
  provider = aws.vpc2
  allocation_id = aws_eip.v2nateip.id
  subnet_id = aws_subnet.v2publicSubnet1.id
  tags = {
    "Name" = "v2tf-natgw"
  }
}

resource "aws_route_table" "v2testPublicRTb" {
  provider = aws.vpc2
  vpc_id = aws_vpc.v2test.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.v2testIGW.id
  }

  tags = {
    "Name" = "v2test-public-rtb"
  }
  route {
    cidr_block = "192.168.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  }
}

resource "aws_route_table" "v2testPrivateRTb" {
  provider = aws.vpc2
  vpc_id = aws_vpc.v2test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.v2tf-natgw.id
  }
  tags = {
    "Name" = "v2test-private-rtb"
  }
}


resource "aws_route_table_association" "v2publicRTbAssociation01" {
  provider = aws.vpc2
  subnet_id = aws_subnet.v2publicSubnet1.id
  route_table_id = aws_route_table.v2testPublicRTb.id
}

resource "aws_route_table_association" "v2privateRTbAssociation01" {
  provider = aws.vpc2
  subnet_id = aws_subnet.v2privateSubnet1.id
  route_table_id = aws_route_table.v2testPrivateRTb.id
}

resource "aws_route_table_association" "v2privateRTbAssociation02" {
  provider = aws.vpc2
  subnet_id = aws_subnet.v2privateSubnet2.id
  route_table_id = aws_route_table.v2testPrivateRTb.id
}

