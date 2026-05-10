#!/bin/bash

# Create Namespace
kubectl create namespace spark-jupyter || true

# 1. Create ServiceAccount and RBAC
# The Jupyter pod acts as the Spark Driver and needs permission to create Executor pods.
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jupyter-serviceaccount
  namespace: spark-jupyter
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: jupyter-role
  namespace: spark-jupyter
rules:
  - apiGroups: [""]
    resources: ["pods", "services", "configmaps"]
    verbs: ["create", "get", "list", "watch", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: jupyter-rolebinding
  namespace: spark-jupyter
subjects:
  - kind: ServiceAccount
    name: jupyter-serviceaccount
    namespace: spark-jupyter
roleRef:
  kind: Role
  name: jupyter-role
  apiGroup: rbac.authorization.k8s.io
EOF

# 2. Create Headless Service for the Driver
# Spark executors need a stable DNS name to connect back to the Driver (the Jupyter pod).
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: jupyter-driver-svc
  namespace: spark-jupyter
spec:
  clusterIP: None
  selector:
    app: jupyterlab
  ports:
    - name: driver
      port: 7077
    - name: blockmanager
      port: 7078
EOF

# 3. Deploy JupyterLab
# Using the 'all-spark-notebook' image which contains Spark, PySpark, and Java.
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jupyterlab
  namespace: spark-jupyter
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jupyterlab
  template:
    metadata:
      labels:
        app: jupyterlab
    spec:
      serviceAccountName: jupyter-serviceaccount
      containers:
      - name: jupyterlab
        image: quay.io/jupyter/all-spark-notebook:latest
        ports:
        - containerPort: 8888
        - containerPort: 7077 # Spark Driver
        - containerPort: 7078 # Block Manager
        env:
        - name: JUPYTER_ENABLE_LAB
          value: "yes"
        - name: JUPYTER_TOKEN
          value: "spark-k8s-pass" # Change this for security
---
apiVersion: v1
kind: Service
metadata:
  name: jupyterlab-ui
  namespace: spark-jupyter
spec:
  type: LoadBalancer # Change to NodePort or ClusterIP if using Ingress
  ports:
    - port: 80
      targetPort: 8888
  selector:
    app: jupyterlab
EOF

echo "Deployment complete. Access JupyterLab via the LoadBalancer IP on port 80."
echo "Token: spark-k8s-pass"