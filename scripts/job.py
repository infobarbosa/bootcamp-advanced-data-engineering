"""crie um script python para um aws glue job que leia um arquivo csv e grave em um bucket s3 em formato parquet.
O arquivo csv está no bucket s3: s3://datalake-raw-curso-dev-desafio/landing-zone/landing-curso-dev-desafio.csv
O arquivo parquet deve ser gravado no bucket s3: s3://datalake-raw-curso-dev-desafio/staging-zone/landing-curso-dev-desafio.parquet
O job deve ser executado diariamente as 23:00 horas.
O job deve ser executado em um endpoint de desenvolvimento.
O job deve ser executado com um papel que tenha acesso de leitura ao bucket de origem e escrita no bucket de destino."""

import boto3
import argparse

# Crie um cliente para interagir com o AWS Glue Service
glue = boto3.client('glue')


# Create an argument parser
parser = argparse.ArgumentParser(description='AWS Glue Job')

# Add the command line arguments
parser.add_argument('--source-bucket', required=True, help='Source bucket for the CSV file')
parser.add_argument('--target-bucket', required=True, help='Target bucket for the Parquet file')
parser.add_argument('--role', required=True, help='ARN of the IAM role')

# Parse the command line arguments
args = parser.parse_args()

# Get the values from the command line arguments
source_bucket = args.source_bucket
target_bucket = args.target_bucket
role = args.role
source_bucket = 's3://datalake-raw-curso-dev-desafio/landing-zone/landing-curso-dev-desafio.csv'
target_bucket = 's3://datalake-raw-curso-dev-desafio/staging-zone/landing-curso-dev-desafio.parquet'
role = 'arn:aws:iam::123456789012:role/GlueJobRole'  # Substitua pelo ARN do seu papel

# Crie o job
response = glue.create_job(
    Name='csv-to-parquet',
    Role=role,
    Command={
        'Name': 'glueetl',
        'ScriptLocation': 's3://my-script-bucket/scripts/csv-to-parquet.py',
        'PythonVersion': '3'
    },
    DefaultArguments={
        '--job-language': 'python',
        '--job-bookmark-option': 'job-bookmark-enable',
        '--TempDir': 's3://my-temp-bucket/temp-dir',
        '--SOURCE_BUCKET': source_bucket,
        '--TARGET_BUCKET': target_bucket
    }
)

# Imprima a resposta
print(response)