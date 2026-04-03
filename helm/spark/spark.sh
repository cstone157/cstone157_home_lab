#!/bin/bash

# This script is used to deploy the Spark Pi example application using Helm.
# kubectl create serviceaccount spark
# kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=default:spark --namespace=default
# helm repo add spark-operator https://kubeflow.github.io/spark-operator
# helm repo update
# helm install my-release spark-operator/spark-operator --namespace spark-operator --create-namespace --set webhook.enable=true
# echo "Waiting for the Spark Operator to be fully deployed..."
# sleep 15 # Wait for the Spark Operator to be fully deployed
# kubectl apply -f spark-pi.yaml

## To uninstall the Spark Operator and the Spark Pi application, you can use the following commands:
# kubectl delete -f spark-pi.yaml
# kubectl delete namespace spark-operator
# kubectl delete clusterrolebinding spark-role
# kubectl delete serviceaccount spark


## ========================================
## Build the Spark Runner Docker image
## ========================================
nerdctl build -t spark-runner:latest -f spark-runner/Dockerfile -namespace=k8s.io ./spark-runner/

## ========================================
## Deploy the Spark/JupyterLab application
## ========================================
## Apply the RBAC configuration for Spark
kubectl apply -f spark-rbac.yaml

sleep 5

## Deploy JupyterLab
kubectl apply -f jupyter-deployment.yaml

## Get the token for JupyterLab access
kubectl logs deployment/jupyterlab | grep "token="

## Enable port forwarding to access JupyterLab
kubectl port-forward svc/jupyterlab-service 8888:8888

## To uninstall the Spark Operator and the JupyterLab deployment, you can use the following commands:
# kubectl delete -f jupyter-deployment.yaml
# kubectl delete -f spark-rbac.yaml
