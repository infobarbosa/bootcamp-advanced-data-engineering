import logging
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

from pyspark.sql import DataFrame, Row
import datetime
from awsglue import DynamicFrame

logging.getLogger().setLevel(logging.INFO)
logging.getLogger("boto3").setLevel(logging.WARNING)
logging.getLogger("botocore").setLevel(logging.WARNING)

args = getResolvedOptions(sys.argv, ['JOB_NAME', 'BUCKET_NAME', 'STREAM_ARN', 'TEMP_DIR'])

JOB_NAME = args['JOB_NAME']
BUCKET_NAME = args['BUCKET_NAME']
STREAM_ARN = args['STREAM_ARN']
TEMP_DIR = args['TEMP_DIR']

logging.info(f"Bucket name: {BUCKET_NAME}")
logging.info(f"Stream ARN: {STREAM_ARN}")

logging.info("Criando o contexto do Glue")
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)
logging.info("Contexto do Glue criado com sucesso")

logging.info("Criando o dataframe de pedidos a partir do Kinesis")
dyfPedidosStream = glueContext.create_data_frame.from_options(
    connection_type="kinesis",
    connection_options={
        "typeOfData": "kinesis",
        "streamARN": STREAM_ARN,
        "classification": "json",
        "startingPosition": "earliest",
        "inferSchema": "true",
    },
    transformation_ctx="dyfPedidosStream",
)

def processBatch(data_frame, batchId):
    if data_frame.count() > 0:
        dyfPedidos = DynamicFrame.fromDF(
            glueContext.add_ingestion_time_columns(data_frame, "hour"),
            glueContext,
            "from_data_frame",
        )

        s3_path = f"s3://{BUCKET_NAME}/raw/ecommerce/pedidos/pedidos-stream/"

        s3_sink = glueContext.getSink(
            path=s3_path,
            connection_type="s3",
            updateBehavior="UPDATE_IN_DATABASE",
            partitionKeys=["ingest_year", "ingest_month", "ingest_day", "ingest_hour"],
            enableUpdateCatalog=True,
            transformation_ctx="s3_sink",
        )
        s3_sink.setCatalogInfo(
            catalogDatabase="ecommerce", catalogTableName="pedidos_stream"
        )
        s3_sink.setFormat("glueparquet", compression="snappy")
        s3_sink.writeFrame(dyfPedidos)


glueContext.forEachBatch(
    frame=dyfPedidosStream,
    batch_function=processBatch,
    options={
        "windowSize": "10 seconds",
        "checkpointLocation": f"{TEMP_DIR}/{JOB_NAME}/checkpoint/",
    },
)
job.commit()
