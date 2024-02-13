# Bootcamp Advanced Data Engineering
# Author: Prof. Barbosa<br>
# Contact: infobarbosa@gmail.com<br>
# Github: [infobarbosa](https://github.com/infobarbosa)

# 06 - Tabelas particionadas (Partitioning)

echo "### Tabela pedidos_part ###"

export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')
echo "Bucket utilizado: $BUCKET_NAME"

export PEDIDOS_S3_LOCATION="s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part"
echo "Localização dos dados de pedidos: $PEDIDOS_S3_LOCATION"

echo "Editando o arquivo pedidos_part.json"
jq --arg S3_LOCATION "$PEDIDOS_S3_LOCATION" '.StorageDescriptor.Location = $S3_LOCATION' 06-Tabelas-Particionadas/assets/scripts/pedidos_part.json > /tmp/pedidos_part.json.tmp
mv /tmp/pedidos_part.json.tmp 06-Tabelas-Particionadas/assets/scripts/pedidos_part.json
cat 06-Tabelas-Particionadas/assets/scripts/pedidos_part.json

aws glue create-table --database-name ecommerce --table-input "file://./06-Tabelas-Particionadas/assets/scripts/pedidos_part.json"
echo "Tabela criada com sucesso! "

echo "Listando as tabelas do banco de dados ecommerce"
aws glue get-tables --database-name 'ecommerce'  --query "TableList[].Name"

echo "Fazendo upload dos arquivos para a pasta particionada"
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-01.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-01/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-02.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-02/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-03.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-03/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-04.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-04/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-05.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-05/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-06.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-06/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-07.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-07/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-08.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-08/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-09.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-09/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-10.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-10/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-11.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-11/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-12.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-12/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-13.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-13/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-14.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-14/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-15.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-15/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-16.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-16/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-17.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-17/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-18.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-18/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-19.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-19/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-20.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-20/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-21.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-21/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-22.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-22/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-23.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-23/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-24.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-24/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-25.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-25/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-26.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-26/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-27.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-27/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-28.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-28/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-29.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-29/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-30.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-30/
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-31.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-31/

echo "Adicionando as partições"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-01')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-02')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-03')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-04')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-05')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-06')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-07')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-08')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-09')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-10')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-11')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-12')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-13')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-14')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-15')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-16')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-17')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-18')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-19')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-20')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-21')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-22')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-23')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-24')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-25')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-26')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-27')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-28')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-29')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-30')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-31')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"

echo "Partições adicionadas com sucesso!"
