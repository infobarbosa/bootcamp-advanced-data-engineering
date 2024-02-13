# Variável de ambiente BUCKET_NAME
export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')

echo $BUCKET_NAME

# Copiando os scripts para o S3
aws s3 cp 08-Glue-Job/assets/scripts/glue-job-clientes.py s3://${BUCKET_NAME}/scripts/glue-job-clientes.py
aws s3 cp 08-Glue-Job/assets/scripts/glue-job-pedidos.py s3://${BUCKET_NAME}/scripts/glue-job-pedidos.py

# Criando as pastas no S3
aws s3api put-object --bucket ${BUCKET_NAME} --key temp/
aws s3api put-object --bucket ${BUCKET_NAME} --key spark-ui/

# Criando o job
aws glue create-job \
    --name glue-job-clientes \
    --role LabRole \
    --command Name=glueetl,ScriptLocation=s3://${BUCKET_NAME}/scripts/glue-job-clientes.py \
    --default-arguments '{"--TempDir": "s3://'"${BUCKET_NAME}"'/temp","--enable-spark-ui": "true","--spark-event-logs-path": "s3://'"${BUCKET_NAME}"'/spark-ui/","--enable-metrics":"true","--enable-job-insights":"true","--enable-continuous-cloudwatch-log":"true","--job-language":"python"}' \
    --cli-input-json "file://08-Glue-Job/assets/scripts/glue-job-clientes.json"

aws glue create-job \
    --name glue-job-pedidos \
    --role LabRole \
    --command Name=glueetl,ScriptLocation=s3://${BUCKET_NAME}/scripts/glue-job-pedidos.py \
    --default-arguments '{"--TempDir": "s3://'"${BUCKET_NAME}"'/temp","--enable-spark-ui": "true","--spark-event-logs-path": "s3://'"${BUCKET_NAME}"'/spark-ui/","--enable-metrics":"true","--enable-job-insights":"true","--enable-continuous-cloudwatch-log":"true","--job-language":"python"}' \
    --cli-input-json "file://08-Glue-Job/assets/scripts/glue-job-pedidos.json"


echo "Executando o job"
aws glue start-job-run --job-name glue-job-clientes
aws glue start-job-run --job-name glue-job-pedidos

echo "Glue jobs iniciados com sucesso!"
