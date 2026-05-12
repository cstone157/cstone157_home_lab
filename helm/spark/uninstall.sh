#!/bin/bash

NAMESPACE="spark-jupyter"

echo "Starting cleanup of Spark-Jupyter components..."

# 1. Delete Services
kubectl delete service jupyterlab-ui -n $NAMESPACE --ignore-not-found
kubectl delete service jupyter-driver-svc -n $NAMESPACE --ignore-not-found

# 2. Delete Deployment (this also stops the Jupyter pod and any active Spark executors)
kubectl delete deployment jupyterlab -n $NAMESPACE --ignore-not-found

# 3. Delete RBAC resources
kubectl delete rolebinding jupyter-rolebinding -n $NAMESPACE --ignore-not-found
kubectl delete role jupyter-role -n $NAMESPACE --ignore-not-found
kubectl delete serviceaccount jupyter-serviceaccount -n $NAMESPACE --ignore-not-found

# 4. Delete the Namespace
kubectl delete namespace $NAMESPACE --ignore-not-found

echo "Cleanup complete. All resources have been removed."
echo ""