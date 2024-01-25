# Variável de ambiente BUCKET_NAME
export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')

echo $BUCKET_NAME

# Copiando o script para o S3
aws s3 cp 08-Glue-Job/assets/scripts/glue-job-ecommerce.py s3://${BUCKET_NAME}/scripts/glue-job-ecommerce.py

# Criando as pastas no S3
aws s3api put-object --bucket ${BUCKET_NAME} --key temp/
aws s3api put-object --bucket ${BUCKET_NAME} --key spark-ui/

# Criando o job
aws glue create-job \
    --name ecommerce_glue_job \
    --role LabRole \
    --command Name=glueetl,ScriptLocation=s3://${BUCKET_NAME}/scripts/glue-job-ecommerce.py \
    --default-arguments '{"--TempDir": "s3://'"${BUCKET_NAME}"'/temp", "--spark-event-logs-path": "s3://'"${BUCKET_NAME}"'/spark-ui/"}' \
    --cli-input-json "file://08-Glue-Job/assets/scripts/glue-job-ecommerce.json"


