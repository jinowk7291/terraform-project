# Security Group for EFS
## Should allow Jenkins Instance ONLY!!!
resource "aws_security_group" "efs" {
  name        = "test"
  description = "testgroup"
  vpc_id      = aws_vpc.test.id

  ingress {
    from_port = 2049 # for NFS

    to_port  = 2049
    protocol = "tcp"
    security_groups = [
      # EC2 Instance Security Group
      aws_security_group.sec-bastion.id,
    ]
  }

  tags = {
    Name = "testgroup"
  }
}

resource "aws_efs_file_system" "file_system" {
  tags = {
    Name = "testgroup"
  }
  

}

resource "aws_efs_mount_target" "mount_target" {
  # If you do not have NAT gateway  or NAT instance in private subnets,
  # You should deploy jenkins to public subnet!
 
  file_system_id = aws_efs_file_system.file_system.id

  subnet_id      = aws_subnet.privateEC2Subnet1.id
  #subnet_id      = element(var.public_subnets, count.index)
  security_groups = [
    aws_security_group.efs.id,
  ]
}

	# create_EFS_Access_Point
resource "aws_efs_access_point" "test" {
	file_system_id = aws_efs_file_system.file_system.id
}
