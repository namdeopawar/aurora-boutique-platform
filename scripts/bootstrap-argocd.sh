#!/usr/bin/env bash
set -euo pipefail

# Installs ArgoCD and boots the platform app-of-apps.
# Requires: kubectl context set to target cluster, cluster-admin perms.

kubectl create namespace argocd 2>/dev/null || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for ArgoCD server to be ready..."
kubectl -n argocd rollout status deploy/argocd-server --timeout=180s

kubectl apply -f argo/bootstrap/argo-project.yaml
kubectl apply -f argo/bootstrap/root-app.yaml

echo "ArgoCD bootstrapped. Default admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
