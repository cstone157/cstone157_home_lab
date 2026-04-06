#!/bin/bash

## ========================================
## Build the Spark Runner Docker image
## ========================================
nerdctl build -t spark-runner:latest -f spark-runner/Dockerfile -namespace=k8s.io ./spark-runner/

## ========================================
## Apply the RBAC configuration for Spark
## ========================================
kubectl apply -f spark-rbac.yaml

sleep 5

## ========================================
## Deploy JupyterLab
## ========================================
kubectl apply -f jupyter-deployment.yaml

## ========================================
## Get the token for JupyterLab access
## ========================================
kubectl logs deployment/jupyterlab | grep "token="

## ========================================
## Enable port forwarding to access JupyterLab
## ========================================
kubectl port-forward svc/jupyterlab-service 8888:8888

## ========================================
## To uninstall the Spark Operator and the 
## JupyterLab deployment, you can use the 
## following commands:
## ========================================
# kubectl delete -f jupyter-deployment.yaml
# kubectl delete -f spark-rbac.yaml
