import sys
import boto3
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
  
print("Definindo a variável s3_bucket que vamos utilizar ao longo do código")
s3_bucket = ""
s3_client = boto3.client('s3')
response = s3_client.list_buckets()

for bucket in response['Buckets']:
    if bucket['Name'].startswith('lab-data-eng-'):
        s3_bucket = bucket['Name']

print("O bucket que vamos utilizar é: " + s3_bucket)

print("Criando o contexto do Glue")
sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

dyf = glueContext.create_dynamic_frame.from_catalog(database='ecommerce', table_name='pedidos_part')
dyf.printSchema()

df = dyf.toDF()
df.show()

print("Limpeza da pasta destino")
response = s3_client.list_objects_v2(Bucket=s3_bucket, Prefix='stage/ecommerce/pedidos/')

for object in response['Contents']:
    out = s3_client.delete_object(Bucket=s3_bucket, Key=object['Key'])

print("Escrevendo os dados no S3")
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
s3output.writeFrame(dyf)

job.commit()
