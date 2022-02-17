resource "helm_release" "argo-cd" {
  name          = "argo-cd"
  chart         = "argo-cd"
  repository    = "https://argoproj.github.io/argo-helm"
  wait          = true
  namespace = "argocd"
  create_namespace = "true"
  values = [
    "${file("argo_values.yaml")}"
  ]
  set {
    name = "server.service.type"
    value = "LoadBalancer"
  }
  set {
    name = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
    value = "${aws_acm_certificate.kubedns.arn}"
  }
  depends_on = [
    aws_eks_cluster.eks_cluster,
    helm_release.aws-load-balancer-controller,
    helm_release.external_dns
  ]
}
