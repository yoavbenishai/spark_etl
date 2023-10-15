from pyspark.sql import SparkSession
import os

source_dir = os.getenv("SOURCE_DIR", "/opt/spark/source")
target_dir = os.getenv("TARGET_DIR", "/opt/spark/target")

spark = SparkSession.builder \
    .getOrCreate()

print(f"reading from {source_dir}/zipcodes.csv")
df = spark.read.option("header", True).csv(f"file://{source_dir}/zipcodes.csv")
df = df.select("State")
df = df.distinct()
print(f"writing to {target_dir}")
# df.write.format("csv").mode('overwrite').save(f"{target_dir}")

df.show()
df.write.format("csv").mode('overwrite').save(f"file://{target_dir}/result")

spark.stop()
