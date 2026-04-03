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


## ==== Script for in the jupyterlab ====
import os
from pyspark.sql import SparkSession

# Get the pod's IP from the environment variable we set in the YAML
pod_ip = os.environ.get("POD_IP")

spark = SparkSession.builder \
    .appName("Jupyter-Spark-K8s") \
    .master("k8s://https://kubernetes.default.svc.cluster.local:443") \
    # .config("spark.kubernetes.container.image", "apache/spark-py:v3.3.1") \
    .config("spark.kubernetes.container.image", "spark-runner:latest") \
    .config("spark.kubernetes.authenticate.driver.serviceAccountName", "spark-jupyter-sa") \
    .config("spark.kubernetes.namespace", "default") \
    .config("spark.driver.host", pod_ip) \
    .config("spark.driver.port", "7077") \
    .config("spark.executor.instances", "2") \
    .config("spark.executor.memory", "1g") \
    .config("spark.executor.cores", "1") \
    .getOrCreate()

print("Spark Running!")


## ==== Spark Script ====
# Test to see if spark can be used to order list
from pyspark.sql.functions import col

# 1. Define a standard Python list of unsorted data
# In this case, a list of tuples representing (Name, Score)
unsorted_list = [
    ("Charlie", 45),
    ("Alice", 85),
    ("Eve", 92),
    ("Bob", 67),
    ("David", 73)
]

# 2. Convert the Python list into a distributed Spark DataFrame
# This sends the data from the Jupyter Driver to the Executor pods
columns = ["Name", "Score"]
df = spark.createDataFrame(unsorted_list, columns)

print("Original Data:")
df.show()

# 3. Submit the job to order the list by the 'Score' column in descending order
# This processing happens in parallel on your Kubernetes Executor pods
ordered_df = df.orderBy(col("Score").desc())

# 4. Bring the results back to Jupyter and display them
print("Ordered Data (Highest Score First):")
ordered_df.show()