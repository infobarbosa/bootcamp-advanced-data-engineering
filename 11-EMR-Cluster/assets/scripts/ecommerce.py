import sys
from datetime import datetime

from pyspark.sql import SparkSession
from pyspark.sql.functions import *

spark = SparkSession \
    .builder \
    .appName("data-eng-lab") \
    .getOrCreate()

spark.catalog.setCurrentDatabase("ecommerce")

dfCli = spark.sql("select * from ecommerce.clientes_parquet")
dfCli.show(5)

dfPed = spark.sql("select * from ecommerce.pedidos_parquet")
dfPed.show(5)

dfPed.write.format("json").mode("overwrite").save("s3://lab-data-eng-202402-p40041/output/")


dfTop10 = spark.sql(
 """SELECT cli.nome, cli.email, sum(ped.quantidade * ped.valor_unitario) total
    FROM clientes_parquet cli
    INNER JOIN pedidos_parquet ped on ped.id_cliente = cli.id
    WHERE ped.data_pedido = '2024-01-01'
    GROUP BY cli.nome, cli.email
    ORDER BY sum(ped.quantidade * ped.valor_unitario) DESC
    LIMIT 10""")

dfTop10.show(10)

dfTop10.write.format("json").mode("overwrite").save("s3://lab-data-eng-202402-p40041/output/top10/")
