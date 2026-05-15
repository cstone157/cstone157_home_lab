from pyspark.sql import SparkSession

 # This line config("spark.kubernetes.executor.podTemplateFile", "/opt/spark/templates/executor-template.yaml") links the template
spark = SparkSession.builder \
    .appName("Spark-No-Resources") \
    .master("k8s://https://kubernetes.default.svc.cluster.local:443") \
    .config("spark.kubernetes.container.image", "quay.io/jupyter/all-spark-notebook:latest") \
    .config("spark.kubernetes.namespace", "spark-jupyter") \
    .config("spark.kubernetes.authenticate.driver.serviceAccountName", "jupyter-serviceaccount") \
    .config("spark.executor.instances", "2") \
    .config("spark.driver.host", "jupyter-driver-svc.spark-jupyter.svc.cluster.local") \
    .config("spark.driver.port", "7077") \
    .config("spark.driver.bindAddress", "0.0.0.0") \
    .config("spark.blockManager.port", "7078") \
    .config("spark.kubernetes.executor.podTemplateFile", "/opt/spark/templates/executor-template.yaml") \
    .getOrCreate()

# Verify
df = spark.range(1, 100)
print(f"Sum: {df.sum()}")