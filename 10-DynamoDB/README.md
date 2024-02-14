# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

## 10 - DynamoDB

O objetivo desta sessão é, através de um Glue Job, executar uma operação analítica e disponibilizar o resultado em uma tabela do AWS DynamoDB.<br>

Desta forma vamos simular um caso de uso real onde dados "frios" precisam ser compilados de forma analítica e disponibilizados em um ambiente transacional para consultas em baixíssima latência.
### 1. Criando a tabela VENDAS_90_DIAS do DynamoDB

Analise os parâmetros do comando `create-table` a seguir e então execute no terminal shell do Cloud9.
```
aws dynamodb create-table \
    --table-name vendas_90_dias \
    --attribute-definitions AttributeName=id_cliente,AttributeType=N \
    --key-schema AttributeName=id_cliente,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

### 2. Exportanto a variável de ambiente BUCKET_NAME
```
export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')
```

```
echo "Bucket: $BUCKET_NAME"
```

### 3. Copiando os scripts para o S3

Analise atentamente o script `glue-job-vendas-90-dias.py` (localizado no diretório `10-DynamoDB/assets/scripts`) e então execute o comando a seguir no terminal shell do Cloud9.
```
aws s3 cp 10-DynamoDB/assets/scripts/glue-job-vendas-90-dias.py s3://${BUCKET_NAME}/scripts/glue-job-vendas-90-dias.py
```

### 4. Criando pastas `temp` e `spark-ui` no S3

As pastas a seguir não têm nada de especial e têm o propósito de suportar a execução do job Glue.
```
aws s3api put-object --bucket ${BUCKET_NAME} --key temp/
```

```
aws s3api put-object --bucket ${BUCKET_NAME} --key spark-ui/
```

### 5. Criando o job

Analise os parâmetros do comando `create-job` a seguir e então execute no terminal shell do Cloud9.<br>
Adicionalmente, analise o conteúdo do script `glue-job-vendas-90-dias.json`, localizado no diretório `10-DynamoDB/assets/scripts/`.

```
aws glue create-job \
    --name glue-job-vendas-90-dias \
    --role LabRole \
    --command Name=glueetl,ScriptLocation=s3://${BUCKET_NAME}/scripts/glue-job-vendas-90-dias.py \
    --default-arguments '{"--TempDir": "s3://'"${BUCKET_NAME}"'/temp","--enable-spark-ui": "true","--spark-event-logs-path": "s3://'"${BUCKET_NAME}"'/spark-ui/","--enable-metrics":"true","--enable-job-insights":"true","--enable-continuous-cloudwatch-log":"true","--job-language":"python"}' \
    --cli-input-json "file://10-DynamoDB/assets/scripts/glue-job-vendas-90-dias.json"
```

### 6. Executando o job

Tudo pronto! Agora podemos ativar o job que acabamos de criar.
```
aws glue start-job-run --job-name glue-job-vendas-90-dias
```

Verifique a execução do job via Console AWS Glue.<br>
Também é possível checar a execução através do comando a seguir:
```
aws glue get-job-runs --job-name glue-job-vendas-90-dias
```

### 7. Verificando a carga
1. Na barra de busca digite `Dynamodb` e então clique em DynamoDB no menu;
2. No menu lateral clique em **Tables**;
3. Clique na tabela `venda_90_dias`;
4. Analise calmamente os parâmetros da tabela;
5. Clique no botão superior à direita **Explore table items**;
6. Explore alguns dos itens (registros) apresentados na tela.

### 8. Conclusão
Parabéns! Nesta sessão você criou uma tabela no DynamoDB e então executou um job Glue para carregá-la com informações analíticas para uso em baixa latência.