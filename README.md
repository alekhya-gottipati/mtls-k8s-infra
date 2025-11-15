mTLS Kubernetes Hello-World Deployment

This repository contains a demonstration of deploying a mutual TLS (mTLS) secured NGINX "Hello World" application on Kubernetes using self-signed certificates. The setup is implemented using Infrastructure as Code (IaC) with Terraform and Kubernetes manifests.

Features

NGINX Hello World app serving a static response

Mutual TLS (mTLS): only clients with valid certificates can access the app

Self-signed server, client, and root CA certificates

Kubernetes Deployment using Deployment, ConfigMap, Secrets

Infrastructure as Code with Terraform to provision the Kubernetes cluster

Verified using curl with client certificate

Repository Structure
mtls-k8s-infra/
├── README.md
├── apps/
│   └── hello-world/
│       ├── deployment.yaml
│       ├── hello-server-tls.yaml
│       ├── ingress.yaml
│       ├── nginx-configmap.yaml
│       ├── root-ca-secret.yaml
│       └── service.yaml
├── certs/
│   ├── generate-certs.sh
│   └── output/
│       ├── client.crt
│       ├── client.key
│       ├── root-ca.crt
│       ├── server.crt
│       └── server.key
├── infra/
│   ├── create-cluster.sh
│   └── terraform/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── scripts/
    └── deploy.sh

Prerequisites

Kubernetes cluster (local: kind/minikube or cloud)

kubectl configured for your cluster

Terraform v1.x installed

Bash or Linux environment

Setup
1. Generate Certificates

Run the certificate generation script:

cd certs
./generate-certs.sh


This creates:

Root CA: root-ca.crt / root-ca.key

Server cert: server.crt / server.key

Client cert: client.crt / client.key

2. Provision Cluster (Optional)

If using Terraform to create a local cluster:

cd infra/terraform
terraform init
terraform plan
terraform apply


This will provision a Kubernetes cluster locally or in the cloud, depending on your Terraform configuration.

3. Deploy Hello-World App
cd scripts
./deploy.sh


This script applies:

Deployment and service

TLS secrets for server and root CA

ConfigMap for NGINX configuration

4. Verify mTLS

Use curl with client certificates to confirm access:

curl -v https://hello.local:8443 \
  --cert certs/output/client.crt \
  --key certs/output/client.key \
  --cacert certs/output/root-ca.crt


Expected response:

Hello from mTLS-secured NGINX!


Without a valid client certificate, the request will be denied.