from pyspark.sql import SparkSession

# spark = SparkSession.builder \
#     .appName("Spark-Best-Effort") \
#     .master("k8s://https://kubernetes.default.svc.cluster.local:443") \
#     .config("spark.kubernetes.container.image", "quay.io/jupyter/all-spark-notebook:latest") \
#     .config("spark.kubernetes.namespace", "spark-jupyter") \
#     .config("spark.kubernetes.authenticate.driver.serviceAccountName", "jupyter-serviceaccount") \
#     .config("spark.executor.instances", "1") \
#     .config("spark.driver.host", "jupyter-driver-svc.spark-jupyter.svc.cluster.local") \
#     .config("spark.driver.port", "7077") \
#     .config("spark.driver.bindAddress", "0.0.0.0") \
#     .config("spark.blockManager.port", "7078") \
#     # 1. Use the template
#     .config("spark.kubernetes.executor.podTemplateFile", "/opt/spark/templates/executor-template.yaml") \
#     # 2. Minimize CPU requests (0.001 is the K8s minimum)
#     .config("spark.kubernetes.executor.request.cores", "1m") \
#     # 3. Minimize Memory requests (Spark ignores this if it's lower than a certain threshold, 
#     # but setting it here helps override the default 1G injection)
#     .config("spark.executor.memory", "512m") \
#     .config("spark.memory.overheadFactor", "0.01") \
#     .getOrCreate()

# spark = SparkSession.builder \
#     .appName("Spark-Best-Effort-Fixed") \
#     .master("k8s://https://kubernetes.default.svc.cluster.local:443") \
#     .config("spark.kubernetes.container.image", "quay.io/jupyter/all-spark-notebook:latest") \
#     .config("spark.kubernetes.namespace", "spark-jupyter") \
#     .config("spark.kubernetes.authenticate.driver.serviceAccountName", "jupyter-serviceaccount") \
#     .config("spark.executor.instances", "1") \
#     .config("spark.driver.host", "jupyter-driver-svc.spark-jupyter.svc.cluster.local") \
#     .config("spark.driver.port", "7077") \
#     .config("spark.driver.bindAddress", "0.0.0.0") \
#     .config("spark.blockManager.port", "7078") \
#     # Point to the template with the fixed command
#     .config("spark.kubernetes.executor.podTemplateFile", "/opt/spark/templates/executor-template.yaml") \
#     # Force requests to near-zero
#     .config("spark.kubernetes.executor.request.cores", "1m") \
#     .config("spark.executor.memory", "512m") \
#     .config("spark.memory.overheadFactor", "0.01") \
#     .getOrCreate()

spark = SparkSession.builder \
    .appName("Spark-Best-Effort-Fixed") \
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

# Test execution
print("Calculating sum...")
print(spark.range(1000).sum())