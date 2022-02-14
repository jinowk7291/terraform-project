resource "aws_iam_policy" "AllowExternalDNSUpdates" {
  name        = "AllowExternalDNSUpdates"
  path        = "/"
  description = "My EKS Route53 policy attach"

  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
    {
      Effect: "Allow",
      Action: [
        "route53:ChangeResourceRecordSets"
      ],
      Resource: [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      Effect: "Allow",
      Action: [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      Resource: [
        "*"
      ]
    }
  ]
 })
}

resource "aws_iam_role" "AllowExternalDNSUpdates" {
  name_prefix         =  "AllowExternalDNSUpdates"
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
            "${replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")}:sub": "system:serviceaccount:default:external-dns"
          }
        }
      },
    ]
  })
  tags = { "external_dns" = "1" }
}
resource "aws_iam_role_policy_attachment" "AllowExternalDNSUpdates" {
  role       = aws_iam_role.AllowExternalDNSUpdates.name
  policy_arn = aws_iam_policy.AllowExternalDNSUpdates.arn
}

