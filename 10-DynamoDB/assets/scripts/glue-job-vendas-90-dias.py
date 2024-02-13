
import sys
import boto3
import time
from awsglue.transforms import *
from pyspark.sql.functions import sum, col, desc, count
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame  

import logging

logging.getLogger().setLevel(logging.INFO)
logging.getLogger("boto3").setLevel(logging.WARNING)
logging.getLogger("botocore").setLevel(logging.WARNING)

logging.info("Criando o contexto do Glue")
sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
logging.info("Contexto do Glue criado com sucesso")

logging.info("Criando o dataframe de clientes")
dyfClientes = glueContext.create_dynamic_frame.from_catalog(database='ecommerce', table_name='clientes_parquet')
dyfClientes.printSchema()

logging.info("Renomeando o atributo ID para evitar colisão com o outro dataset e eliminando os atributos CPF e data_nasc")
dyfClientes = dyfClientes.drop_fields(["cpf","data_nasc"])
dyfClientes = dyfClientes.rename_field("id", "id_cli")
dyfClientes.toDF().show(5)

logging.info("Criando o dataframe de pedidos considerando apenas os últimos 90 dias")
dyfPedidos = glueContext.create_dynamic_frame.from_catalog(database='ecommerce', table_name='pedidos_parquet', push_down_predicate = "CAST(data_pedido AS DATE) >= CURRENT_DATE - INTERVAL '90' DAY")
dyfPedidos.printSchema()
dyfPedidos.toDF().show(5)

logging.info("Eliminando atributo produto, desnecessário nesta operação")
dyfPedidos = dyfPedidos.drop_fields(["produto"])
dyfPedidos.toDF().show(5)

logging.info("Criando um novo atributo VALOR_TOTAL")
dfPedidos = dyfPedidos.toDF()
dfPedidos = dfPedidos.withColumn("valor_total", col("quantidade") * col("valor_unitario"))
dyfPedidos = DynamicFrame.fromDF(dfPedidos, glueContext, "dyfPedidos")

logging.info("Eliminando os atributos quantidade e valor_unitario")
dyfPedidos = dyfPedidos.drop_fields(["quantidade", "valor_unitario"])

logging.info("Join de dyfPedidos com dyfClientes para obter o nome e email dos clientes")
dyfClientesPedidos = dyfClientes.join(paths1=["id_cli"], paths2=["id_cliente"], frame2=dyfPedidos)
dyfClientesPedidos.toDF().show(5)

logging.info("Converte para dataframe para realizar a agregação")
dfClientesPedidos = dyfClientesPedidos.toDF()

dfVendas90Dias = dfClientesPedidos.groupBy("id_cliente", "nome", "email") \
        .agg(sum("valor_total").alias("valor_total") \
            ,count("id_pedido").alias("qtd_pedidos")) 

dyfVendas90Dias = DynamicFrame.fromDF(dfVendas90Dias, glueContext, "dyfVendas90Dias")

logging.info("Escrevendo o dataframe no DynamoDB")
glueContext.write_dynamic_frame.from_options(
    frame = DynamicFrame.fromDF(dyfVendas90Dias, glueContext, "nested"),
    connection_type = "dynamodb",
    connection_options = {"dynamodb.output.tableName": "vendas_90_dias",
                            "dynamodb.throughput.write.percent": "1.0",
                            "dynamodb.region": "us-east-1",
                            "dynamodb.output.retry": "100",
                            "dynamodb.output.numparalleltasks": "1"}
)

job.commit()