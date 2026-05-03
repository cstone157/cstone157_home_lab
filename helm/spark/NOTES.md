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

