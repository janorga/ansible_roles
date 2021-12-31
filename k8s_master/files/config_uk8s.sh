#! /bin/bash

DNS_IP="193.145.250.101"
METAL_RANGE="10.5.0.5-10.5.0.100"

sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube

microk8s status --wait-ready

sudo apt install -y open-iscsi curl
sudo systemctl enable iscsid
microk8s enable dns:${DNS_IP}
microk8s enable openebs ingress helm3
microk8s enable metallb:${METAL_RANGE}

microk8s kubectl apply -f ingress-service.yaml

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
