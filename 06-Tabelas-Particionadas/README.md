# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 06 - Tabelas particionadas (Partitioning)

O objetivo desta sessão é criar particionar a tabela `pedidos` no Glue Catalog considerando a data do pedido .<br>

## Via AWS CLI (terminal)

### Tabela `pedidos_part`

##### 1. Edite o arquivo `pedidos_part.json` para considerar o bucket criado no exercício **02-Bucket-S3**.
> - O arquivo se encontra no diretório `06-Tabelas-Particionadas/assets/scripts/`;
> - Utilize o editor do Cloud9.

##### 2. Crie a variável de ambiente `BUCKET_NAME`
```
export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')
```

```
echo $BUCKET_NAME
```

##### 3. Examine o conteúdo do arquivo `06-Tabelas-Particionadas/assets/scripts/pedidos_part.json` 
> - Perceba o atributo **PartitionKeys** que especifica `data_pedido` como chave de partição.<br>
> - Ajuste o atributo **Location** com nome do bucket que você criou no exercício **02-Bucket-S3** <br>
> Ex.: `"Location":"s3://SEU_BUCKET_AQUI/raw/ecommerce/pedidos/part/"`

##### 4. Crie a tabela `pedidos_part`
```
aws glue create-table --database-name ecommerce --table-input "file://./06-Tabelas-Particionadas/assets/scripts/pedidos_part.json"
```

##### 5. Verifique se a tabela `pedidos_part` foi criada corretamente:
```
aws glue get-tables --database-name 'ecommerce'  --query "TableList[].Name"
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ aws glue get-tables --database-name 'ecommerce'  --query "TableList[].Name"
[
    "clientes",
    "pedidos",
    "pedidos_part"
]
```

##### 6. Faça o upload de um arquivo para a pasta particionada:
> Atenção! <br>
> Perceba que agora estamos fazendo o upload para outra pasta diferente da que utilizamos no exercício **03-Datasets**.<br>
> Com este comando nós criaremos duas sub-pastas: `part` e, embaixo desta, `data_pedido=2024-01-01`.

```
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-01.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-01/
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-01.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-01/
upload: 03-Datasets/assets/data/pedidos-2024-01-01.csv.gz to s3://lab-data-eng-202402-p40041/raw/ecommerce/pedidos/part/data_pedido=2024-01-01/pedidos-2024-01-01.csv.gz
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ 
```

##### 7. No **Athena**, abra um editor SQL e execute a seguinte consulta:
> Utilize o conhecimento adquirido no exercício **05-Athena**

```
SELECT count(1) qtt
FROM "ecommerce"."pedidos_part";
```

Perceba que (provavelmente) nenhum dado retornou. Isso ocorre porque a tabela está particionada porém o catálogo (Glue Catalog) não detecta automaticamente a existência de partições.<br>
Outra maneira de checar a disponibilidade das partições é através do comando `SHOW PARTITIONS`:
```
SHOW PARTITIONS ecommerce.pedidos_part;
```

##### 8. Vamos resolver isso via comando `ALTER TABLE .. ADD PARTITION`:

Ainda no editor SQL do Athena, digite:
```
ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-01');
```
Este atualiza o catálogo de dados caso detecte novas partições.

> Para saber mais sobre o comando `ALTER TABLE ADD PARTITION` clique [aqui](https://docs.aws.amazon.com/athena/latest/ug/alter-table-add-partition.html) <br>
> Outro comando interessante é o `MSCK REPAIR TABLE` que pode ser encontrado [aqui](https://docs.aws.amazon.com/athena/latest/ug/msck-repair-table.html)

##### 9. [OPCIONAL] O comando acima também pode ser executado no terminal Cloud9:

```
aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-01')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ aws athena start-query-execution --query-string "ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-01')" --result-configuration "OutputLocation=s3://${BUCKET_NAME}/results/"
{
    "QueryExecutionId": "82a1906f-8c3a-4dad-8b21-366bd896152a"
}
```

---

# [OPCIONAL] Eliminando tabelas
Caso precise eliminar alguma tabela, você pode fazer isso via terminal com o seguinte comando:
```
aws glue delete-table --database-name ecommerce --name pedidos_part
```
