from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.context import SparkContext
from awsglue.dynamicframe import DynamicFrame

# Inicialize o Spark e Glue context
sc = SparkContext()
glueContext = GlueContext(sc)
job = Job(glueContext)

# Defina os parâmetros do job
source_bucket = 's3://datalake-raw-curso-dev-desafio/landing-zone/landing-curso-dev-desafio.csv.gz'
target_bucket = 's3://datalake-raw-curso-dev-desafio/staging-zone/landing-curso-dev-desafio.parquet'

# Crie um DynamicFrame lendo o arquivo CSV
dynamic_frame = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": [source_bucket]},
    format="csv",
    format_options={"compression": "gzip"}
)

# Converta o DynamicFrame para Parquet e grave no bucket de destino
glueContext.write_dynamic_frame.from_options(
    frame=dynamic_frame,
    connection_type="s3",
    connection_options={"path": target_bucket},
    format="parquet"
)

# Commit o job
job.commit()