resource "kubernetes_namespace" "ns" {
  metadata { name = var.namespace }
}

resource "helm_release" "ingress_nginx" {
  count            = var.install_ingress_nginx ? 1 : 0
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  wait             = true
}

resource "helm_release" "microapp" {
  name      = "microapp"
  namespace = kubernetes_namespace.ns.metadata[0].name
  chart     = "${path.module}/../helm/microapp"
  wait      = true

  set {
    name  = "ingress.className"
    value = var.ingress_class
  }

  set {
    name  = "ingress.host"
    value = var.ingress_host
  }

  set {
    name  = "api.image.repository"
    value = var.api_image_repo
  }

  set {
    name  = "api.image.tag"
    value = var.api_image_tag
  }

  set {
    name  = "web.image.repository"
    value = var.web_image_repo
  }

  set {
    name  = "web.image.tag"
    value = var.web_image_tag
  }

  set_sensitive {
    name  = "db.password"
    value = var.db_password
  }

  set {
    name  = "db.persistence.size"
    value = var.db_pvc_size
  }

  dynamic "set" {
    for_each = var.db_storage_class == null ? [] : [var.db_storage_class]
    content {
      name  = "db.persistence.storageClass"
      value = set.value
    }
  }

  depends_on = [kubernetes_namespace.ns]
}
