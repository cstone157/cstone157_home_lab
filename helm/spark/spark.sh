#!/bin/bash

# Create Namespace
kubectl create namespace spark-jupyter || true

# 1. Create a Pod Template ConfigMap
# This template defines the executor pod structure without resource requests.
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: spark-pod-template
  namespace: spark-jupyter
data:
  executor-template.yaml: |
    apiVersion: v1
    kind: Pod
    spec:
      containers:
      - name: spark-kubernetes-executor # Spark looks for this specific name
        resources:
          requests: null  # Explicitly nullify requests
          limits: null    # Explicitly nullify limits
EOF

# 2. Create ServiceAccount and RBAC
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

# 3. Create Headless Service for Spark Driver
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

# 4. Deploy JupyterLab with Template Mounted
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
        - containerPort: 7077
        - containerPort: 7078
        env:
        - name: JUPYTER_ENABLE_LAB
          value: "yes"
        - name: JUPYTER_TOKEN
          value: "spark-k8s-pass"
        volumeMounts:
        - name: spark-template-volume
          mountPath: /opt/spark/templates
      volumes:
      - name: spark-template-volume
        configMap:
          name: spark-pod-template
---
apiVersion: v1
kind: Service
metadata:
  name: jupyterlab-ui
  namespace: spark-jupyter
spec:
  type: NodePort
  ports:
    - port: 8888
      targetPort: 8888
      nodePort: 30088
  selector:
    app: jupyterlab
EOF

echo "Deployment complete. NodePort: 30088"