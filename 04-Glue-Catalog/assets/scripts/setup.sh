# Bootcamp Advanced Data Engineering
# Author: Prof. Barbosa<br>
# Contact: infobarbosa@gmail.com<br>
# Github: [infobarbosa](https://github.com/infobarbosa)

# 04 - Glue Catalog

export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')
export CLIENTES_S3_LOCATION="s3://${BUCKET_NAME}/raw/ecommerce/clientes/"
export PEDIDOS_S3_LOCATION="s3://${BUCKET_NAME}/raw/ecommerce/pedidos/"

echo "Database ecommerce"
aws glue create-database --database-input "{\"Name\":\"ecommerce\"}" 

echo "Database criado"
aws glue get-databases

echo "Tabela tb_raw_clientes"
jq --arg S3_LOCATION "$CLIENTES_S3_LOCATION" '.StorageDescriptor.Location = $S3_LOCATION' 04-Glue-Catalog/assets/scripts/clientes.json > /tmp/clientes.json.tmp
mv /tmp/clientes.json.tmp 04-Glue-Catalog/assets/scripts/clientes.json

aws glue create-table --database-name ecommerce --table-input "file://04-Glue-Catalog/assets/scripts/clientes.json"

echo "Tabela tb_raw_pedidos"
jq --arg S3_LOCATION "$PEDIDOS_S3_LOCATION" '.StorageDescriptor.Location = $S3_LOCATION' 04-Glue-Catalog/assets/scripts/pedidos.json > /tmp/pedidos.json.tmp
mv /tmp/pedidos.json.tmp 04-Glue-Catalog/assets/scripts/pedidos.json

aws glue create-table --database-name ecommerce --table-input "file://04-Glue-Catalog/assets/scripts/pedidos.json"

echo "Tabelas criadas"
aws glue get-tables --database-name 'ecommerce'  --query "TableList[].Name"
echo "Localização das tabelas"
aws glue get-tables --database-name 'ecommerce'  --query "TableList[].StorageDescriptor.Location"
