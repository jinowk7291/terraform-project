resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "node_group1"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = ["${aws_subnet.privateEC2Subnet1.id}","${aws_subnet.privateEC2Subnet2.id}"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  remote_access {
    ec2_ssh_key = "mysoldesktestkey"
    source_security_group_ids = ["${aws_security_group.sec-bastion.id}"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.CloudWatchAgentServerPolicy
  ]
}
resource "aws_iam_role" "eks_nodes" {
  name = "eks-node-group"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_nodes.name
}
#output "arn" {
#  value = aws_iam_role.
#}
