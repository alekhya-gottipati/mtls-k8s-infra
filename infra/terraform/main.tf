terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-${var.cluster_name}"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "kind-${var.cluster_name}"
  }
}

# -------------------------------
# Namespace
# -------------------------------
resource "kubernetes_namespace" "hello_world" {
  metadata {
    name = var.namespace
  }
}

# -------------------------------
# TLS Secret (Server certificate)
# -------------------------------
resource "kubernetes_secret" "tls_secret" {
  metadata {
    name      = var.tls_secret_name
    namespace = kubernetes_namespace.hello_world.metadata[0].name
  }
  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = filebase64("${path.module}/../../certs/output/server.crt")
    "tls.key" = filebase64("${path.module}/../../certs/output/server.key")
  }
}

# -------------------------------
# Root CA Secret (for mTLS)
# -------------------------------
resource "kubernetes_secret" "root_ca_secret" {
  metadata {
    name      = var.root_ca_secret_name
    namespace = kubernetes_namespace.hello_world.metadata[0].name
  }
  data = {
    "ca.crt" = filebase64("${path.module}/../../certs/output/root-ca.crt")
  }
}

# -------------------------------
# Deployments, Services, Ingress
# -------------------------------
resource "kubernetes_manifest" "hello_deployment" {
  manifest = yamldecode(file("${path.module}/../../apps/hello-world/deployment.yaml"))
}

resource "kubernetes_manifest" "hello_service" {
  manifest = yamldecode(file("${path.module}/../../apps/hello-world/service.yaml"))
}

resource "kubernetes_manifest" "hello_ingress" {
  manifest = yamldecode(file("${path.module}/../../apps/hello-world/ingress.yaml"))
}
