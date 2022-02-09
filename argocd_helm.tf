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
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}
