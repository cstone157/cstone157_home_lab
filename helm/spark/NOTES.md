## ==== Script for in the jupyterlab ====
import os
from pyspark.sql import SparkSession

# Get the pod's IP from the environment variable we set in the YAML
pod_ip = os.environ.get("POD_IP")

spark = SparkSession.builder \
    .appName("Jupyter-Spark-K8s") \
    .master("k8s://https://kubernetes.default.svc.cluster.local:443") \
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


#### Delete the application
- $ kubectl delete sparkapp spark-pi

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

## ==== Close spark session ====
# Stop the Spark session and release resources
spark.stop()

print("Spark session closed.")
