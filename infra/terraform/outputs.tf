output "namespace_name" {
  description = "Namespace where Hello World app is deployed"
  value       = kubernetes_namespace.hello_world.metadata[0].name
}

output "tls_secret_name" {
  description = "TLS Secret name"
  value       = kubernetes_secret.tls_secret.metadata[0].name
}

output "root_ca_secret_name" {
  description = "Root CA Secret name"
  value       = kubernetes_secret.root_ca_secret.metadata[0].name
}
