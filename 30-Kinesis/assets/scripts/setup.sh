# Bootcamp Advanced Data Engineering
# Author: Prof. Barbosa<br>
# Contact: infobarbosa@gmail.com<br>
# Github: [infobarbosa](https://github.com/infobarbosa)

echo "Exportanto a variável de ambiente BUCKET_NAME"
export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')
echo "Bucket: $BUCKET_NAME"

echo "Exportanto a variável de ambiente STREAM_ARN"
export STREAM_ARN=$(aws kinesis list-streams | jq '.StreamSummaries[].StreamARN' | tr -d '"')
echo "Stream: $STREAM_ARN"

echo "Copiando os scripts para o S3"
aws s3 cp 30-Kinesis/assets/scripts/glue-job-pedidos-stream.py s3://${BUCKET_NAME}/scripts/glue-job-pedidos-stream.py

echo "Criando as pastas no S3"
aws s3api put-object --bucket ${BUCKET_NAME} --key temp/
aws s3api put-object --bucket ${BUCKET_NAME} --key spark-ui/

echo "Criando o job"
aws glue create-job \
    --name glue-job-pedidos-stream \
    --role LabRole \
    --command Name=gluestreaming,ScriptLocation=s3://${BUCKET_NAME}/scripts/glue-job-pedidos-stream.py \
    --default-arguments '{"--BUCKET_NAME"='"${BUCKET_NAME}"',"--STREAM_ARN"='"${STREAM_ARN}"',"--TEMP_DIR": "s3://'"${BUCKET_NAME}"'/temp","--enable-spark-ui": "true","--spark-event-logs-path": "s3://'"${BUCKET_NAME}"'/spark-ui/","--enable-metrics":"true","--enable-job-insights":"true","--enable-continuous-cloudwatch-log":"true","--job-language":"python"}' \
    --cli-input-json "file://30-Kinesis/assets/scripts/glue-job-pedidos-stream.json"

echo "Executando o job"
aws glue start-job-run --job-name glue-job-pedidos-stream

echo "Glue jobs iniciados com sucesso!"
