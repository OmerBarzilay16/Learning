output "namespace" { value = kubernetes_namespace.ns.metadata[0].name }
output "ingress_host" { value = var.ingress_host }
output "microapp_status" { value = helm_release.microapp.status }