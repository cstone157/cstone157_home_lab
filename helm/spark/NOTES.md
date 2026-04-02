#

### 1.) Installing the spark operator (https://github.com/kubeflow/spark-operator)

### 2.) Create Namespace

- $ kubectl create namespace spark-apps

### 3.) Create Service Account

- $ kubectl apply -f spark-pi.yaml

### 4.) Create Spark application

- $ kubectl apply -f spark-app.yaml (NOT WORKING)


#### Delete the application
- $ kubectl delete sparkapp spark-pi


#

## Deploying using the Spark Operator

## Set up RBAC (Role-Based Access Control)

- $ kubectl create serviceaccount spark
- $ kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=default:spark --namespace=default

### Install the operator with helm

- $ helm repo add spark-operator https://kubeflow.github.io/spark-operator
- $ helm repo update
- $ helm install my-release spark-operator/spark-operator --namespace spark-operator --create-namespace --set webhook.enable=true

### Install a spark application using spark-pi.yaml

- $ kubectl apply -f spark-pi.yaml

### Accessing the UI

- $ kubectl port-forward my-release-spark-operator-webhook-<hash> -n spark-operator 4040:4040