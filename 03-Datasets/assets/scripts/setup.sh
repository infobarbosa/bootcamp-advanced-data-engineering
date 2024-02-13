# Bootcamp Advanced Data Engineering
# Author: Prof. Barbosa<br>
# Contact: infobarbosa@gmail.com<br>
# Github: [infobarbosa](https://github.com/infobarbosa)

# 03 - Bases de dados

# Listando os arquivos disponíveis em `assets\data`
ls -la 03-Datasets/assets/data/

# Criando uma variável de ambiente `BUCKET_NAME`
export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')

echo "Nome do bucket: $BUCKET_NAME"

# Executando o upload da base de clientes
aws s3 cp 03-Datasets/assets/data/clientes.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/clientes/ 

# Conferindo se o upload ocorreu como esperado:
aws s3 ls s3://${BUCKET_NAME}/raw/ecommerce/clientes/

# Executando o upload da base de pedidos
aws s3 cp 03-Datasets/assets/data/ s3://${BUCKET_NAME}/raw/ecommerce/pedidos/ --recursive --exclude "*" --include "pedidos*"

# Conferindo se o upload ocorreu como esperado:
aws s3 ls s3://${BUCKET_NAME}/raw/ecommerce/pedidos/
