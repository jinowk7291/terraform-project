resource "helm_release" "prometheus" {
  name          = "prometheus"
  chart         = "kube-prometheus-stack"
  repository    = "https://prometheus-community.github.io/helm-charts"
  wait          = true
  namespace = "monitoring"
  create_namespace = "true"
  values = [
    "${file("prometheus_values.yaml")}"
  ]

  depends_on = [
    aws_eks_cluster.eks_cluster,
    helm_release.aws-load-balancer-controller
  ]
}

