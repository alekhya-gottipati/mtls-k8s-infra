variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "mtls-hello"
}

variable "namespace" {
  description = "Kubernetes namespace for Hello World app"
  type        = string
  default     = "hello-world"
}

variable "tls_secret_name" {
  description = "TLS Secret for the server"
  type        = string
  default     = "hello-server-tls"
}

variable "root_ca_secret_name" {
  description = "Root CA Secret for mTLS"
  type        = string
  default     = "root-ca-secret"
}
