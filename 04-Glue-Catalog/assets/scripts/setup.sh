# Bootcamp Advanced Data Engineering
# Author: Prof. Barbosa<br>
# Contact: infobarbosa@gmail.com<br>
# Github: [infobarbosa](https://github.com/infobarbosa)

# 04 - Glue Catalog


echo "Database ecommerce"
aws glue create-database --database-input "{\"Name\":\"ecommerce\"}" 

echo "Database criado"
aws glue get-databases


echo "Tabela tb_raw_clientes"
aws glue create-table --database-name ecommerce --table-input "file://04-Glue-Catalog/assets/scripts/clientes.json"

echo "Tabela tb_raw_pedidos"
aws glue create-table --database-name ecommerce --table-input "file://04-Glue-Catalog/assets/scripts/pedidos.json"

echo "Tabelas criadas"
aws glue get-tables --database-name 'ecommerce'  --query "TableList[].Name"
echo "Localização das tabelas"
aws glue get-tables --database-name 'ecommerce'  --query "TableList[].StorageDescriptor.Location"
