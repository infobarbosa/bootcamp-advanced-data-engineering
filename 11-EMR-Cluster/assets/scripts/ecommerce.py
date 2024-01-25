import sys
from datetime import datetime

from pyspark.sql import SparkSession
from pyspark.sql.functions import *

spark = SparkSession \
    .builder \
    .config("spark.sql.catalog.spark_catalog", "org.apache.iceberg.spark.SparkSessionCatalog") \
    .config("spark.sql.catalog.spark_catalog.type", "hive") \
    .appName("data-eng-lab") \
    .getOrCreate()

spark.catalog.setCurrentDatabase("ecommerce")

dfCli = spark.sql("select * from ecommerce.clientes_parquet")
dfCli.show(5)

dfPed = spark.sql("select * from ecommerce.pedidos_parquet")
dfPed.show(5)

dfPed.write.format("json").mode("overwrite").save("s3://lab-data-eng-202402-p40041/output/")
