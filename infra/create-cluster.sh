#!/bin/bash
# -------------------------------
# Create a local Kubernetes cluster using KIND
# -------------------------------

set -e

CLUSTER_NAME="mtls-hello"

echo "Creating Kind cluster: ${CLUSTER_NAME}..."
kind create cluster --name ${CLUSTER_NAME} --wait 60s

echo "Cluster created. Getting kubeconfig..."
kubectl cluster-info --context kind-${CLUSTER_NAME}

echo "Cluster ready!"
