# Bootcamp Advanced Data Engineering
# Author: Prof. Barbosa<br>
# Contact: infobarbosa@gmail.com<br>
# Github: [infobarbosa](https://github.com/infobarbosa)

echo "Criando a tabela VENDAS_90_DIAS do DynamoDB"
aws dynamodb create-table \
    --table-name vendas_90_dias \
    --attribute-definitions AttributeName=id_cliente,AttributeType=N \
    --key-schema AttributeName=id_cliente,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
echo "Tabela vendas_90_dias criada com sucesso!"

echo "Exportanto a variável de ambiente BUCKET_NAME"
export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')

echo "Bucket: $BUCKET_NAME"

echo "Copiando os scripts para o S3"
aws s3 cp 10-DynamoDB/assets/scripts/glue-job-vendas-90-dias.py s3://${BUCKET_NAME}/scripts/glue-job-vendas-90-dias.py

echo "Criando as pastas no S3"
aws s3api put-object --bucket ${BUCKET_NAME} --key temp/
aws s3api put-object --bucket ${BUCKET_NAME} --key spark-ui/

echo "Criando o job"
aws glue create-job \
    --name glue-job-vendas-90-dias \
    --role LabRole \
    --command Name=glueetl,ScriptLocation=s3://${BUCKET_NAME}/scripts/glue-job-vendas-90-dias.py \
    --default-arguments '{"--TempDir": "s3://'"${BUCKET_NAME}"'/temp","--enable-spark-ui": "true","--spark-event-logs-path": "s3://'"${BUCKET_NAME}"'/spark-ui/","--enable-metrics":"true","--enable-job-insights":"true","--enable-continuous-cloudwatch-log":"true","--job-language":"python"}' \
    --cli-input-json "file://10-DynamoDB/assets/scripts/glue-job-vendas-90-dias.json"


echo "Executando o job"
aws glue start-job-run --job-name glue-job-vendas-90-dias

echo "Glue jobs iniciados com sucesso!"
