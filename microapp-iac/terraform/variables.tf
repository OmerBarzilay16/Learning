variable "kubeconfig_path" {
  description = "Path to your kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubeconfig context to use (null = current context)"
  type        = string
  default     = null
}

variable "namespace" {
  description = "Namespace to deploy into"
  type        = string
  default     = "microapp"
}

variable "install_ingress_nginx" {
  description = "Whether to install ingress-nginx via Helm"
  type        = bool
  default     = true
}

variable "ingress_class" {
  description = "Ingress class name used by the microapp chart"
  type        = string
  default     = "nginx"
}

variable "ingress_host" {
  description = "Host for the Ingress"
  type        = string
  default     = "microapp.local"
}

variable "api_image_repo" {
  type    = string
  default = "omerbarzolay16/microapp-api"
}

variable "api_image_tag" {
  type    = string
  default = "0.1"
}

variable "web_image_repo" {
  type    = string
  default = "omerbarzolay16/microapp-web"
}

variable "web_image_tag" {
  type    = string
  default = "0.1"
}

variable "db_password" {
  description = "Postgres password"
  type        = string
  sensitive   = true
  default     = "micropass"
}

variable "db_pvc_size" {
  description = "Postgres PVC size"
  type        = string
  default     = "1Gi"
}

variable "db_storage_class" {
  description = "StorageClass name for Postgres PVC (null = default)"
  type        = string
  default     = null
}