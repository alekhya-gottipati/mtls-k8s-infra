# scripts/deploy.sh
#!/bin/bash
set -e

echo "==============================================="
echo "Step 1: Applying Terraform to provision cluster"
echo "==============================================="
cd infra/terraform
terraform init
terraform apply -auto-approve

echo
echo "==============================================="
echo "Step 2: Switching to Kubernetes context"
echo "==============================================="
# Ensure kubectl is using the right cluster/context if needed
# Example for kind: kubectl cluster-info --context kind-cluster-name

echo
echo "==============================================="
echo "Step 3: Creating hello-world namespace (if not exists)"
echo "==============================================="
kubectl get ns hello-world >/dev/null 2>&1 || kubectl create ns hello-world

echo
echo "==============================================="
echo "Step 4: Applying ConfigMap, Secrets, and Deployment"
echo "==============================================="
kubectl apply -f apps/hello-world/nginx-configmap.yaml -n hello-world
kubectl apply -f apps/hello-world/root-ca-secret.yaml -n hello-world
kubectl apply -f apps/hello-world/hello-server-tls.yaml -n hello-world
kubectl apply -f apps/hello-world/deployment.yaml -n hello-world
kubectl apply -f apps/hello-world/service.yaml -n hello-world
kubectl apply -f apps/hello-world/ingress.yaml -n hello-world || echo "Ingress not applied (optional)"

echo
echo "==============================================="
echo "Step 5: Verifying resources"
echo "==============================================="
kubectl get ns
kubectl get secrets -n hello-world
kubectl get deploy -n hello-world
kubectl get pods -n hello-world
kubectl get svc -n hello-world
kubectl get ingress -n hello-world || echo "No ingress found"

echo
echo "==============================================="
echo "Deployment complete. Your mTLS NGINX app should be running!"
echo "Use curl with client certificates to verify:"
echo "curl -v https://hello.local:8443 --cert certs/output/client.crt --key certs/output/client.key --cacert certs/output/root-ca.crt"
echo "==============================================="
