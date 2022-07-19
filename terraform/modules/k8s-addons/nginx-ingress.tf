resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    annotations = {
      name = "nginx-ingress"
    }

    name = "nginx-ingress"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  chart      = "nginx-ingress/ingress-nginx"
  version    = "4.1.4"
  namespace = "nginx-ingress"

  depends_on = [
    kubernetes_namespace.nginx_ingress
  ]
}

## ADD The LoadBalancer IP attached to the ingress controller as the * registry for the zone

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-ingress-nginx-controller"
    namespace = helm_release.nginx_ingress.metadata[0].namespace
  }
}

resource "aws_route53_record" "this" {
  zone_id = var.dns_zone_id #aws_route53_zone.this.zone_id
  name    = "*"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname]
}
