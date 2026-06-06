#### ========================================================================================================================================
#### Gnerate spark sessions
#### ========================================================================================================================================
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Spark-K8s-Entrypoint-Fix") \
    .master("k8s://https://kubernetes.default.svc.cluster.local:443") \
    .config("spark.kubernetes.container.image", "quay.io/jupyter/all-spark-notebook:latest") \
    .config("spark.kubernetes.namespace", "spark-jupyter") \
    .config("spark.kubernetes.authenticate.driver.serviceAccountName", "jupyter-serviceaccount") \
    .config("spark.executor.instances", "1") \
    .config("spark.driver.host", "jupyter-driver-svc.spark-jupyter.svc.cluster.local") \
    .config("spark.driver.port", "7077") \
    .config("spark.driver.bindAddress", "0.0.0.0") \
    .config("spark.blockManager.port", "7078") \
    .config("spark.kubernetes.executor.podTemplateFile", "/opt/spark/templates/executor-template.yaml") \
    .config("spark.kubernetes.executor.request.cores", "1m") \
    .config("spark.executor.memory", "512m") \
    .config("spark.memory.overheadFactor", "0.01") \
    .getOrCreate()

# Test the connection
print("Spark Session successfully initialized.")
print(spark.range(10).collect())



#### ========================================================================================================================================
#### Delete the application
#### ========================================================================================================================================
- $ kubectl delete sparkapp spark-pi

#### ========================================================================================================================================
## ==== Spark Script ====
# Test to see if spark can be used to order list
#### ========================================================================================================================================
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