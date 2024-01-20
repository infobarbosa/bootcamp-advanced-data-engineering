# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 06 - Tabelas particionadas (Partitioning)

O objetivo desta sessão é criar particionar a tabela `pedidos` no Glue Catalog considerando a data do pedido .<br>

## Via AWS CLI (terminal)

### Tabela `pedidos_part`
> #### Atenção!
> Neste exercívio é necessário editar o arquivo `assets/scripts/pedidos_part.json` para considerar o bucket criado no exercício **02-Bucket-S3**.

1. Crie a variável de ambiente `BUCKET_NAME`
```
export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')
```

```
echo $BUCKET_NAME
```

2. Examine o conteúdo do arquivo `06-Tabelas-Particionadas/assets/scripts/pedidos_part.json` 
> - Perceba o atributo **PartitionKeys** que especifica `data_pedido` como chave de partição.<br>
> - Ajuste o atributo **Location** com nome do bucket que você criou no exercício **02-Bucket-S3** <br>
> Ex.: `"Location":"s3://SEU_BUCKET_AQUI/raw/ecommerce/pedidos/part/"`

3. Crie a tabela `pedidos_part`
```
aws glue create-table --database-name ecommerce --table-input "./06-Tabelas-Particionadas/assets/scripts/pedidos_part.json"
```

4. Faça o upload de um arquivo para a pasta particionada:
```
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-01.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-01/
```

5. No **Athena**, abra um editor SQL e execute a seguinte consulta:
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

Vamos resolver isso via comando `MSCK REPAIR TABLE`:
```
MSCK REPAIR TABLE ecommerce.pedidos_part;
```
Este comando verifica e atualiza o catálogo de dados caso detecte novas partições.


---

# Eliminando tabelas
Caso precise eliminar alguma tabela, você pode fazer isso via terminal com o seguinte comando:
```
aws glue delete-table --database-name ecommerce --name pedidos_part
```
