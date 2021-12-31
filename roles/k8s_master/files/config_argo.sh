#!/bin/bash

# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Download Argo CD CLI
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

# Wait untill Argo is Ready
kubectl -n argocd rollout status deployment argocd-server
kubectl -n argocd rollout status deployment argocd-repo-server
kubectl -n argocd rollout status deployment argocd-redis
kubectl -n argocd rollout status deployment argocd-dex-server
sleep 5

# Access The Argo CD API Server
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Get Password & login
PASSWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
SVC_IP=$(kubectl -n argocd get svc argocd-server | grep argocd-server | awk '{print $4}')

argocd login ${SVC_IP} --insecure --username admin --password ${PASSWD}

# Adding Mircok8s cluster
argocd cluster add microk8s -y

# Output passwd

echo ""
echo "Passsword for Argo is ${PASSWD}"
echo ""

exit 0
