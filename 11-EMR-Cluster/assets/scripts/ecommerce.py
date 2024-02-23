import os
import sys
import boto3
from datetime import datetime

from pyspark.sql import SparkSession
from pyspark.sql.functions import *

print("Iniciando o script de processamento dos dados: data-eng-lab")
spark = SparkSession \
    .builder \
    .appName("data-eng-lab") \
    .config("hive.metastore.client.factory.class", "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory") \
    .enableHiveSupport() \
    .getOrCreate()

spark.catalog.setCurrentDatabase("ecommerce")

print("Definindo a variavel BUCKET_NAME que vamos utilizar ao longo do codigo")
BUCKET_NAME = ""
s3_client = boto3.client('s3')
response = s3_client.list_buckets()

for bucket in response['Buckets']:
    if bucket['Name'].startswith('lab-data-eng-'):
        BUCKET_NAME = bucket['Name']

print("O bucket que vamos utilizar serah: " + BUCKET_NAME)

print("Obtendo os dados de pedidos")
dfPed = spark.sql("select * from ecommerce.pedidos_parquet")
dfPed.show(5)

print("Escrevendo os dados de pedidos no S3")
dfPed.write.format("json").mode("overwrite").save("s3://" + BUCKET_NAME + "/output/pedidos")

print("Executando consulta dos top 10 clientes")
dfTop10 = spark.sql(
 """SELECT cli.nome, cli.email, sum(ped.quantidade * ped.valor_unitario) total
    FROM clientes_parquet cli
    INNER JOIN pedidos_parquet ped on ped.id_cliente = cli.id
    WHERE ped.data_pedido = '2024-01-01'
    GROUP BY cli.nome, cli.email
    ORDER BY sum(ped.quantidade * ped.valor_unitario) DESC
    LIMIT 10""")

dfTop10.show(10)

print("Escrevendo os dados dos top 10 clientes no S3")
dfTop10.write.format("json").mode("overwrite").save("s3://" + BUCKET_NAME + "/output/top10/")

print("job finalizado")
