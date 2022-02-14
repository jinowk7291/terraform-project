resource "helm_release" "external_dns" {
  name          = "external-dns"
  chart         = "external-dns"
  repository    = "https://kubernetes-sigs.github.io/external-dns/"
  wait          = true
  values = [
    "${file("externaldns_values.yaml")}"
  ]
  set {
    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.AllowExternalDNSUpdates.arn}"
  }
  set {
  name = "txtOwnerId"
  value = "${aws_route53_zone.kubedns.zone_id}"
  }
  depends_on = [
    aws_eks_cluster.eks_cluster,
    helm_release.aws-load-balancer-controller,
  ]
}
output "id"  {
  value = aws_route53_zone.kubedns.zone_id
}
