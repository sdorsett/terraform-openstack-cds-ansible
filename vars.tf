variable "private_key" {
  default = "~/.ssh/id_rsa"
}

variable "public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "github_client_id" {
  default = "GITHUB_CLIENT_ID"
}

variable "github_client_secret" {
  default = "GITHUB_CLIENT_SECRET"
}

variable "cds_nginx_fqdn" {
  default = "XXX_CDS_NGINX_FQDN_XXX"
}

variable "kubernetes_certificate" {
  default = "XXXXXX"
}

variable "kubernetes_token" {
  default = "XXXXXX"
}

variable "kubernetes_user" {
  default = "cds-user"
}

variable "kubernetes_namespace" {
  default = "cds"
}

variable "kubernetes_endpoint" {
  default = "https://kubernetes.example.com:6443"
}
