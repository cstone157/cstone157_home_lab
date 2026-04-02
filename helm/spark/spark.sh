#!/bin/bash

# This script is used to deploy the Spark Pi example application using Helm.
kubectl create serviceaccount spark
kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=default:spark --namespace=default
helm repo add spark-operator https://kubeflow.github.io/spark-operator
helm repo update
helm install my-release spark-operator/spark-operator --namespace spark-operator --create-namespace --set webhook.enable=true
echo "Waiting for the Spark Operator to be fully deployed..."
sleep 15 # Wait for the Spark Operator to be fully deployed
# kubectl apply -f spark-pi.yaml

## To uninstall the Spark Operator and the Spark Pi application, you can use the following commands:
# kubectl delete -f spark-pi.yaml
# kubectl delete namespace spark-operator
# kubectl delete clusterrolebinding spark-role
# kubectl delete serviceaccount spark
