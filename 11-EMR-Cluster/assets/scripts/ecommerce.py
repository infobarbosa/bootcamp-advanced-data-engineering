import sys
from datetime import datetime

from pyspark.sql import SparkSession
from pyspark.sql.functions import *

spark = SparkSession\
    .builder\
    .appName("data-eng-lab")\
    .getOrCreate()

spark.catalog.setCurrentDatabase("ecommerce")
df = spark.sql("select * from clientes")
df.show(5)

df.write.format("json").mode("overwrite").save("s3://lab-data-eng-202402-p40041/output/")
