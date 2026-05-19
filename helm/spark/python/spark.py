from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Spark-K8s-Success") \
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

# Verify the fix
print("Testing Spark connection...")
print(spark.range(1, 1000).sum())