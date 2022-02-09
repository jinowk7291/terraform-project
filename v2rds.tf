resource "aws_db_subnet_group" "testSubnetGroup" {
  provider = aws.vpc1
  name = "test"
  subnet_ids = [
    aws_subnet.privateRDSSubnet1.id,
    aws_subnet.privateRDSSubnet2.id
  ]

  tags = {
    "Name" = "test-subnet-group"
  }

}

resource "aws_db_subnet_group" "testSubnetGroup2" {
  provider = aws.vpc2
  name = "test2"
  subnet_ids = [
    aws_subnet.v2privateSubnet1.id, 
    aws_subnet.v2privateSubnet2.id
  ]

  tags = {
    "Name" = "test-subnet-group2"
  }

}



resource "aws_db_instance" "testDB" {
  provider = aws.vpc1
  identifier             = "test-mysql"
  name                   = "testDB"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  skip_final_snapshot    = true
  #publicly_accessible    = true
  vpc_security_group_ids = ["${aws_security_group.sec-peer.id}"]
  username               = "root"
  password               = var.db_password
  port = "3306"
  availability_zone = "ap-northeast-2a"
  db_subnet_group_name = aws_db_subnet_group.testSubnetGroup.name
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 1
}

resource "aws_db_instance" "testDB-read" {
  provider = aws.vpc2
  identifier             = "test-mysql-read"
  name                   = "testDB2"
  instance_class         = "db.t2.micro"
  replicate_source_db    = aws_db_instance.testDB.arn
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${aws_security_group.sec-peer2.id}"]
  username = ""
  password = ""
  availability_zone = "ap-northeast-1a"
  db_subnet_group_name = aws_db_subnet_group.testSubnetGroup2.name
  backup_retention_period = 0
}
