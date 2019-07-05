#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

################################################################################
# BASE install

echo "Using the follwing input: cluster $CLUSTER_NAME v$KUBERNETES_VERSION with $NUM_WORKERS workers"

# first, provision EKS control and data plane using eksctl:
eksctl create cluster \
    --name $CLUSTER_NAME \
    --version $KUBERNETES_VERSION \
    --nodes $NUM_WORKERS \
    --auto-kubeconfig \
    --full-ecr-access \
    --appmesh-access

# let's wait up to 5 minutes for the nodes the get ready:
echo "Now waiting up to 5 min for cluster to be usable ..."
kubectl wait nodes --for=condition=Ready --timeout=300s --all

################################################################################
# ADDONS install

# install ArgoCD based off of:
# https://argoproj.github.io/argo-cd/getting_started/
echo "Now installing ArgoCD ..."
kubectl create namespace argocd
kubectl -n argocd apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# install App Mesh and o11y components (Prometheus, Grafana, X-Ray)
# based off of: https://github.com/PaulMaddox/aws-appmesh-helm

# install the default Kube dashboard based off of:
# https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html

echo "DONE"