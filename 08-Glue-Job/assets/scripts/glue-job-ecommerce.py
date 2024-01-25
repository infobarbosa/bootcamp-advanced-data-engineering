
import sys
import boto3
import time
from awsglue.transforms import *
from pyspark.sql.functions import sum, col, desc
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame  

print("Criando o contexto do Glue")
sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
print("Contexto do Glue criado com sucesso")
print("Definindo a variável s3_bucket que vamos utilizar ao longo do código")
s3_bucket = ""
s3_client = boto3.client('s3')
response = s3_client.list_buckets()

for bucket in response['Buckets']:
    if bucket['Name'].startswith('lab-data-eng-'):
        s3_bucket = bucket['Name']

print("O bucket que vamos utilizar é: " + s3_bucket)
dyfClientes = glueContext.create_dynamic_frame.from_catalog(database='ecommerce', table_name='clientes')
dyfClientes.printSchema()
dyfPedidos = glueContext.create_dynamic_frame.from_catalog(database='ecommerce', table_name='pedidos_part')
dyfPedidos.printSchema()
dfCli = dyfClientes.toDF()
dfCli.show(5)
dfPed = dyfPedidos.toDF()
dfPed.show(5)
# Primeiro vamos limpar a pasta destino
response = s3_client.list_objects_v2(Bucket=s3_bucket, Prefix='stage/ecommerce/clientes/')

for object in response['Contents']:
    out = s3_client.delete_object(Bucket=s3_bucket, Key=object['Key'])
s3output = glueContext.getSink(
  path="s3://" + s3_bucket + "/stage/ecommerce/clientes/",
  connection_type="s3",
  updateBehavior="UPDATE_IN_DATABASE",
  partitionKeys=[],
  compression="snappy",
  enableUpdateCatalog=True,
  transformation_ctx="s3output",
)
s3output.setCatalogInfo(
  catalogDatabase="ecommerce", catalogTableName="clientes_parquet"
)
s3output.setFormat("glueparquet")
s3output.writeFrame(dyfClientes)
# Primeiro vamos limpar a pasta destino
response = s3_client.list_objects_v2(Bucket=s3_bucket, Prefix='stage/ecommerce/pedidos/')

for object in response['Contents']:
    out = s3_client.delete_object(Bucket=s3_bucket, Key=object['Key'])
s3output = glueContext.getSink(
  path="s3://" + s3_bucket + "/stage/ecommerce/pedidos/",
  connection_type="s3",
  updateBehavior="UPDATE_IN_DATABASE",
  partitionKeys=["data_pedido"],
  compression="snappy",
  enableUpdateCatalog=True,
  transformation_ctx="s3output",
)
s3output.setCatalogInfo(
  catalogDatabase="ecommerce", catalogTableName="pedidos_parquet"
)
s3output.setFormat("glueparquet")
s3output.writeFrame(dyfPedidos)
session = boto3.Session()
s3 = session.resource('s3')
lab_eng_bucket = s3.Bucket(s3_bucket)

print("Arquivos de clientes em stage")
for clientes_object in lab_eng_bucket.objects.filter(Prefix="stage/ecommerce/clientes/"):
    print(clientes_object.key)

print("Arquivos de pedidos em stage")
for pedidos_object in lab_eng_bucket.objects.filter(Prefix="stage/ecommerce/pedidos/"):
    print(pedidos_object.key)

dyfClientes = glueContext.create_dynamic_frame.from_catalog(database='ecommerce', table_name='clientes_parquet')
dyfClientes.printSchema()
dyfClientes.toDF().show(5)
data_pedido="2024-01-01"
dyfPedidos = glueContext.create_dynamic_frame.from_catalog(database='ecommerce', table_name='pedidos_parquet', push_down_predicate = "data_pedido='"+ data_pedido +"'")
dyfPedidos.printSchema()
dyfPedidos.toDF().show(5)
# Renomeando o atributo ID para evitar colisão com o outro dataset
# Eliminando atributos desnecessários nesta operação
dyfClientes = (
    dyfClientes.drop_fields(["cpf","data_nasc"])
    .rename_field("id", "id_cli")
)

dyfClientes.toDF().show(5)
#Eliminando atributo produto, desnecessário nesta operação
dyfPedidos = dyfPedidos.drop_fields(["produto"])

# Criando um novo atributo VALOR_TOTAL
dfPedidos = dyfPedidos.toDF()
dfPedidos = dfPedidos.withColumn("valor_total", col("quantidade") * col("valor_unitario"))
dyfPedidos = DynamicFrame.fromDF(dfPedidos, glueContext, "dyfPedidos")

# Agora podemos eliminar os atributos quantidade e valor_unitario
dyfPedidos = dyfPedidos.drop_fields(["quantidade", "valor_unitario"])
# Vamos fazer o join com dyfClientes para obter o nome e email dos clientes
dyfClientesPedidos = dyfClientes.join(paths1=["id_cli"], paths2=["id_cliente"], frame2=dyfPedidos)
dyfClientesPedidos.toDF().show(5)
# Converte para dataframe
dfClientesPedidos = dyfClientesPedidos.toDF()

dfTop10 = dfClientesPedidos.groupBy("id_cliente", "nome", "email") \
        .agg(sum("valor_total").alias("tot")) \
        .sort(desc("tot")) \
        .limit(10)
# Primeiro vamos limpar a pasta destino
response = s3_client.list_objects_v2(Bucket=s3_bucket, Prefix='analytics/ecommerce/relatorios/top10pedidosdia/')

for object in response['Contents']:
    out = s3_client.delete_object(Bucket=s3_bucket, Key=object['Key'])
dyfTop10 = DynamicFrame.fromDF(dfTop10, glueContext, "dyfTop10")

s3output = glueContext.getSink(
  path="s3://" + s3_bucket + "/analytics/ecommerce/relatorios/top10pedidosdia/",
  connection_type="s3",
  updateBehavior="UPDATE_IN_DATABASE",
  partitionKeys=[],
  compression="snappy",
  enableUpdateCatalog=True,
  transformation_ctx="s3output",
)
s3output.setCatalogInfo(
  catalogDatabase="ecommerce", catalogTableName="top_10_pedidos_dia"
)
s3output.setFormat("glueparquet")
s3output.writeFrame(dyfTop10)
job.commit()