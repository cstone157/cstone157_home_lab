from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("K8s-Spark-NodePort-Env") \
    .master("k8s://https://kubernetes.default.svc.cluster.local:443") \
    .config("spark.kubernetes.container.image", "quay.io/jupyter/all-spark-notebook:latest") \
    .config("spark.kubernetes.namespace", "spark-jupyter") \
    .config("spark.kubernetes.authenticate.driver.serviceAccountName", "jupyter-serviceaccount") \
    .config("spark.executor.instances", "2") \
    .config("spark.driver.host", "jupyter-driver-svc.spark-jupyter.svc.cluster.local") \
    .config("spark.driver.port", "7077") \
    .config("spark.driver.bindAddress", "0.0.0.0") \
    .config("spark.blockManager.port", "7078") \
    .getOrCreate()

# Verify it works
print("Spark Session Created. Executors should be appearing in 'kubectl get pods -n spark-jupyter'")
spark.range(1000).sum()