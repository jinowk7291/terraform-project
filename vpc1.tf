resource "aws_vpc" "test" {
  provider = "aws.vpc1"
  cidr_block = "192.168.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  
  tags = {
    "Name" = "terraform-test-vpc"
  }
}

resource "aws_subnet" "publicSubnet1" {
  provider = "aws.vpc1"
  vpc_id = aws_vpc.test.id
  cidr_block = "192.168.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "test-public-subnet-01"
    "kubernetes.io/cluster/terraformEKScluster" = "shared"
    "kubernetes.io/role/elb" = 1 
  }
}


resource "aws_subnet" "publicSubnet2" {
  provider = "aws.vpc1"
  vpc_id = aws_vpc.test.id
  cidr_block = "192.168.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name" = "test-public-subnet-02"
    "kubernetes.io/cluster/terraformEKScluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "privateEC2Subnet1" {
  provider = "aws.vpc1"
  vpc_id = aws_vpc.test.id
  cidr_block = "192.168.3.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "test-private-ec2-subnet-01"
  }
}

resource "aws_subnet" "privateEC2Subnet2" {
  provider = "aws.vpc1"
  vpc_id = aws_vpc.test.id
  cidr_block = "192.168.4.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name" = "test-private-ec2-subnet-02"
  }
}

resource "aws_subnet" "privateRDSSubnet1" {
  provider = "aws.vpc1"
  vpc_id = aws_vpc.test.id
  cidr_block = "192.168.5.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name" = "test-private-rds-subnet-01"
  }
}

resource "aws_subnet" "privateRDSSubnet2" {
  provider = "aws.vpc1"
  vpc_id = aws_vpc.test.id
  cidr_block = "192.168.6.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name" = "test-private-rds-subnet-02"
  }
}

resource "aws_internet_gateway" "testIGW" {
  provider = "aws.vpc1"
  vpc_id = aws_vpc.test.id
  tags = {
    "Name" = "testIGW"
  }
}

resource "aws_eip" "nateip" {
  provider = "aws.vpc1"
  vpc = true
}

resource "aws_nat_gateway" "tf-natgw" {
  provider = "aws.vpc1"
  allocation_id = aws_eip.nateip.id
  subnet_id = aws_subnet.publicSubnet2.id
  tags = {
    "Name" = "tf-natgw"
  }
}

resource "aws_route_table" "testPublicRTb" {
  provider = "aws.vpc1"
  vpc_id = aws_vpc.test.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIGW.id
  }

  tags = {
    "Name" = "test-public-rtb"
  }
  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  }
}

resource "aws_route_table" "testPrivateRTb" {
  vpc_id = aws_vpc.test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf-natgw.id
  }
  tags = {
    "Name" = "test-private-rtb"
  }
}


resource "aws_route_table_association" "publicRTbAssociation01" {
  subnet_id = aws_subnet.publicSubnet1.id
  route_table_id = aws_route_table.testPublicRTb.id
}

resource "aws_route_table_association" "publicRTbAssociation02" {
  subnet_id = aws_subnet.publicSubnet2.id
  route_table_id = aws_route_table.testPublicRTb.id
}

resource "aws_route_table_association" "privateRTbAssociation01" {
  subnet_id = aws_subnet.privateEC2Subnet1.id
  route_table_id = aws_route_table.testPrivateRTb.id
}

resource "aws_route_table_association" "privateRTbAssociation02" {
  subnet_id = aws_subnet.privateEC2Subnet2.id
  route_table_id = aws_route_table.testPrivateRTb.id
}

resource "aws_route_table_association" "privateRTbAssociation03" {
  subnet_id = aws_subnet.privateRDSSubnet1.id
  route_table_id = aws_route_table.testPrivateRTb.id
}

resource "aws_route_table_association" "privateRTbAssociation04" {
  subnet_id = aws_subnet.privateRDSSubnet2.id
  route_table_id = aws_route_table.testPrivateRTb.id
}
