resource "helm_release" "argo-cd" {
  name          = "argo-cd"
  chart         = "argo-cd"
  repository    = "https://argoproj.github.io/argo-helm"
  wait          = true

  values = [
   file("helm_set_argocd.yaml")
  ]

  depends_on = [
    helm_release.aws-load-balancer-controller
  ]
  
}
