import sys
import boto3
import time

athena_client = boto3.client('athena')
s3_bucket = ""

def get_s3_bucket():
    if s3_bucket == "":
        set_s3_bucket()

    return s3_bucket

def set_s3_bucket():
    print("Definindo a variável s3_bucket que vamos utilizar ao longo do código")
    s3_client = boto3.client('s3')
    response = s3_client.list_buckets()

    for bucket in response['Buckets']:
        if bucket['Name'].startswith('lab-data-eng-'):
            s3_bucket = bucket['Name']

    print("O bucket que vamos utilizar é: " + s3_bucket)

def execute_athena_query():  
    response = athena_client.start_query_execution(
        QueryString="SELECT COUNT(1) qtt FROM pedidos_parquet",
        QueryExecutionContext={
            'Database': "ecommerce"
        },
        ResultConfiguration={
            'OutputLocation': "s3://" + get_s3_bucket + "/results"
        }
    )
    return response['QueryExecutionId']

def get_query_status(query_execution_id):
    response = athena_client.get_query_execution(
        QueryExecutionId=query_execution_id
    )
    status = response['QueryExecution']['Status']['State']
    print("O status da consulta é: " + status)
    return status

def get_query_results(query_execution_id):
    response = athena_client.get_query_results(
        QueryExecutionId=query_execution_id
    )
    # Imprimindo o resultado da consulta
    for row in response['ResultSet']['Rows']:
        print([field['VarCharValue'] for field in row['Data']])

def main():
    query_execution_id = execute_athena_query()
    status = get_query_status(query_execution_id)
    while status == 'QUEUED' or status == 'RUNNING':
        print("Consulta ainda em execução...")
        time.sleep(5)  # Espera alguns segundos antes de verificar novamente
        status = get_query_status(query_execution_id)
        
    if get_query_status(query_execution_id) == 'SUCCEEDED':
        print("Imprimindo resultado: ")
        get_query_results(query_execution_id)
    else:
        print("Consulta falhou! query_execution_id=" + query_execution_id)


if __name__ == "__main__":
    main()
