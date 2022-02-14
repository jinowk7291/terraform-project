resource "helm_release" "aws-load-balancer-controller" {
  name          = "aws-load-balancer-controller"
  chart         = "aws-load-balancer-controller"
  repository    = "https://aws.github.io/eks-charts"
  namespace     = "kube-system"
  wait          = true

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.cluster.name
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_lb_controller.arn
  }
  depends_on = [
    aws_iam_role_policy_attachment.aws_lb_controller,
    aws_eks_cluster.eks_cluster
  ]
}

resource "aws_iam_policy" "aws_lb_controller" {
  name_prefix   =  "aws_lb_controller"
  policy        = file("AWSLoadBalancerControllerIAMPolicy.json")
  tags = { "aws_alb_policy" = "1" }
}

resource "aws_iam_role" "aws_lb_controller" {
  name_prefix         =  "aws_lb_controller"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.cluster.arn
        }
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
          } 
        }
      },
    ]
  })
  tags = { "aws_alb_role" = "1" }
}


resource "aws_iam_role_policy_attachment" "aws_lb_controller" {
  role       = aws_iam_role.aws_lb_controller.name
  policy_arn = aws_iam_policy.aws_lb_controller.arn
}


