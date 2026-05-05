#!/bin/bash

# # Create namespace and service account
# kubectl create namespace spark
# kubectl create serviceaccount spark -n spark

# # Grant permissions (RBAC)
# kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=spark:spark --namespace=spark

# bin/spark-submit \
#     --master k8s://https://<K8S_API_SERVER_URL> \
#     --deploy-mode cluster \
#     --name spark-pi \
#     --class org.apache.spark.examples.SparkPi \
#     --conf spark.executor.instances=3 \
#     --conf spark.kubernetes.container.image=apache/spark:latest \
#     --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
#     --conf spark.kubernetes.namespace=spark \
#     local:///opt/spark/examples/jars/spark-examples_2.12-3.5.0.jar