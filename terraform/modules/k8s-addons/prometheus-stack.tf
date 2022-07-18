resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring"
    }

    name = "monitoring"
  }
}

resource "helm_release" "prometheus-stack" {
  name = "prometheus-stack"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "37.2.0"
  namespace  = "monitoring"

}