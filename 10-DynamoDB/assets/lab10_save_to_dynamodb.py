import sys
import boto3    
import re 
from botocore.exceptions import ClientError

from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from functools import partial
from pyspark.sql.functions import col, lit, when, udf, from_unixtime, unix_timestamp, to_timestamp, to_date, date_format, year, month, dayofmonth, hour, minute, second, date_trunc, to_utc_timestamp, from_utc_timestamp, from_unixtime, unix_timestamp, to_timestamp, to_date, date_format, year, month, dayofmonth, hour, minute, second, date_trunc, to_utc_timestamp, from_utc_timestamp, from_unixtime, unix_timestamp, to_timestamp, to_date, date_format, year, month, dayofmonth, hour, minute, second, date_trunc, to_utc_timestamp, from_utc_timestamp, from_unixtime, unix_timestamp, to_timestamp, to_date, date_format, year, month, dayofmonth, hour, minute, second, date_trunc, to_utc_timestamp, from_utc_timestamp
from datetime import datetime, timedelta, date
from pyspark.sql.types import StringType, IntegerType, LongType, DoubleType, DecimalType, StructType, StructField, TimestampType, DateType, ArrayType, MapType, BooleanType, NullType
from awsglue.dynamicframe import DynamicFrame

import logging

logging.getLogger().setLevel(logging.INFO)
logging.getLogger("boto3").setLevel(logging.WARNING)
logging.getLogger("botocore").setLevel(logging.WARNING)


def main():    
    sc = SparkContext()
    glueContext = GlueContext(sc)
    spark = glueContext.spark_session
    job = Job(glueContext)

    args = getResolvedOptions(sys.argv, ['JOB_NAME', 's3_bucket', 's3_prefix', 'dynamodb_table'])
    s3_bucket = args['s3_bucket']
    s3_prefix = args['s3_prefix']
    dynamodb_table = args['dynamodb_table']
    s3_path = "s3://{}/{}".format(s3_bucket, s3_prefix)

    logging.info("s3_bucket: {}".format(s3_bucket))
    logging.info("s3_prefix: {}".format(s3_prefix))
    logging.info("dynamodb_table: {}".format(dynamodb_table))
    logging.info("s3_path: {}".format(s3_path))

    # Read data from S3
    df = spark.read.parquet(s3_path)
    df.printSchema()
    df.show(5)

    # Write data to DynamoDB
    glueContext.write_dynamic_frame.from_options(
        frame = DynamicFrame.fromDF(df, glueContext, "nested"),
        connection_type = "dynamodb",
        connection_options = {"dynamodb.output.tableName": dynamodb_table,
                                "dynamodb.throughput.write.percent": "1.0",
                                "dynamodb.region": "us-east-1",
                                "dynamodb.output.retry": "100",
                                "dynamodb.output.numparalleltasks": "1"}
    )


    job.commit()


if __name__ == "__main__":
    main()
    
