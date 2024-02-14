# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 07 - Glue Crawler

O objetivo desta sessão é apresentar o Glue Crawler como ferramenta de descoberta de dados e metadados.<br>
No exercício **04-Glue-Catalog**, nós criamos as tabelas `clientes` e `pedidos` com base em definições pré-estabelecidas. O que acontece quando temos um dataset para o qual não temos uma definição sobre os metadados do seu conteúdo?<br>
Já no exercício anterior, **06-Tabelas-Particionadas**, adicionamos partições manualmente via comando `ALTER TABLE ADD PARTITION`.<br>
No dia-a-dia esse processo manual é inviável então uma automação se torna necessária.<br>

Neste exercício faremos algo simples, criação de tabela (`tb_crawler_clientes`) e adição de partições (`pedidos_part`). Porém, o Glue Crawler possui várias possibilidades de conexão a sistemas de armazenamento (S3, bancos de dados relacionais, etc.) para determinar alterações de estrutura (schema) e então criar ou atualizar metadados de tabelas no catálogo de dados (Glue Catalog).


## Via console AWS

## Clientes

### Crie o crawler `crawler_clientes`
1. No console AWS, digite `glue` na barra de pesquisa e então clique em **AWS Glue**;
2. No painel lateral (esquerda), abaixo de **Databases**, clique em **Tables**;
3. Na tela que se abrir clique no botão **Add tables using crawler**;
4. Em **name**, digite `crawler_clientes`;
5. Clique no botão **Next** ao final da página;
6. Clique em **Add a data source**
    - Em **Data source** escolha S3
    - Em **Location of S3 data** mantenha **In this account**
    - Em **S3 path** informe `s3://[SEU BUCKET AQUI]/raw/ecommerce/clientes/` ajustando para o nome do seu bucket.
    - Mantenha as demais configurações inalteradas
    - Clique no botão **Add an S3 data source** ao final da página
7. De volta à tela **Choose data sources and classifiers** clique no botão **Next** ao final da página;
8. Na tela **Configure security settings**, em **IAM Role** escolha `LabRole`;
9. Clique no botão **Next** ao final da página;
10. Na tela **Set output and scheduling**, em **Target database** escolha `ecommerce`;
11. Em **Table name prefix** informe `tb_crawler_`;
12. Em **Crawler schedule**, no campo **Frequency** mantenha `On demand` ;
13. Clique no botão **Next** ao final da página;
13. Na tela **Review and create**, revise as configurações e então clique em **Create crawler** ao final da página.

Você então receberá a mensagem a seguir no topo da tela
```
One crawler successfully created
The following crawler is now created: "crawler_clientes"
```

### Execute do crawler `crawler_clientes`
1. Na página de crawlers, selecione o crawler `crawler_clientes` e clique em `Run` no topo à direita da página

    > ### Atenção!
    > O status do crawler ficará em **Running** por cerca de 3 minutos. Ao final do processamento o status mudará para **Ready**


### Inspecione a tabela `tb_crawler_clientes`
Se tudo ocorreu como esperado, o crawler terá criado uma tabela `tb_crawler_clientes`.
1. No painel lateral (esquerdo), clique em Databases;
2. Clique no link do database `ecommerce`;
3. Na sessão **Tables**, clique em `tb_crawler_clientes`;
4. Examine os metadados da tabela;
5. Abra o Athena e inspecione o conteúdo da tabela `tb_crawler_clientes`;
    > Utilize o conhecimento adquirido no exercício **05-Athena**.


## Pedidos
> Atenção!<br>
> Este procedimento **não** é exatamente igual ao utilizado para a tabela `tb_crawler_clientes`.

Diferente do que fizemos no crawler `crawler_clientes`, este exercício pretende demonstrar como o crawler `crawler_pedidos` automatiza o processo de adição de partições na tabela `pedidos_part`.

### Crie o crawler `crawler_pedidos`
1. No console AWS, digite `glue` na barra de pesquisa e então clique em **AWS Glue**;
2. No painel lateral (esquerda), abaixo de **Data Catalog**, clique em **Crawlers**;
3. Na tela que se abrir clique no botão **Create crawler**;
4. Em **Name**, digite `crawler_pedidos`;
5. Clique no botão **Next** ao final da página;
6. Na tela **Choose data sources and classifiers**, na sessão **Data source configuration**, perceba a pergunta **Is your data already mapped to Glue tables?** (Seu dados já estão mapeados para tabelas Glue?);
7. Em **Is your data already mapped to Glue tables?** clique em **Yes**;
8. Na sessão **Glue tables**, clique em **Add tables**;
9. Na tela **Add Glue tables**, no combo **Database** escolha `ecommerce`;
10. No combo **Tables** selecione apenas a tabela `pedidos_part`;
    > Atenção! **Não** confundir com a tabela `tb_raw_pedidos`.
11. Clique no botão **Confirm**;
12. De volta à tela **Choose data sources and classifiers**, clique em **Next**;
13. Na tela **Configure security settings**, na sessão **IAM role**, abra o combo **Existing IAM role** e escolha `LabRole`;
14. Clique em **Next** ao fim da página;
15. Na tela **Set output and scheduling**, abra a sessão **Advanced options**;
16. Na sessão **Advanced options**, marque o radion button **Ignore the change and don't update the table in the data catalog**;
17. Ainda na sessão **Advanced options**, selecione o checkbox **Update all new and existing partitions with metadata from the table**;
18. Na tela **Set output and scheduling**, na sessão **Crawler schedule**, no combo **Frequency** mantenha `On demand` ;
19. Clique no botão **Next** ao final da página;
20. Na tela **Review and create**, revise as configurações e então clique em **Create crawler** ao final da página.

Você então receberá a mensagem a seguir no topo da tela:
```
One crawler successfully created
The following crawler is now created: "crawler_pedidos"
```

### Inspecione a tabela `pedidos_part`
1. No painel lateral (esquerdo), clique em **Databases**;
2. Clique no link do database `ecommerce`;
3. Na sessão **Tables**, clique em `pedidos_part`;
4. Mais abaixo, clique na aba **Partitions**;
    > Repare que a tabela possui apenas uma partição (data_pedido=2024-01-01) que adicionamos no exercício **06-Tabelas-Particionadas**;

### Adicione uma nova partição à tabela `pedidos_part`
1. Volte ao terminal do Cloud9
2. Verifique se você está no diretório `/home/ubuntu/environment/bootcamp-advanced-data-engineering`;
```
pwd
```
Caso não esteja, navegue para o diretório:
```
cd /home/ubuntu/environment/bootcamp-advanced-data-engineering
```

3. Crie a variável de ambiente `BUCKET_NAME`
```
export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')
```

```
echo $BUCKET_NAME
```

4. Faça o upload de um novo arquivo para a pasta particionada:
> Com este comando nós criaremos uma nova sub-pasta `data_pedido=2024-01-02` embaixo da pasta `part`.

```
aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-02.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-02/
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ aws s3 cp ./03-Datasets/assets/data/pedidos-2024-01-02.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-02/
upload: 03-Datasets/assets/data/pedidos-2024-01-02.csv.gz to s3://lab-data-eng-202402-p40041/raw/ecommerce/pedidos/part/data_pedido=2024-01-02/pedidos-2024-01-02.csv.gz
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ 
```

5. Verifique se o arquivo foi carregado corretamente:
```
aws s3 ls s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-02/
```
Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ aws s3 ls s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/data_pedido=2024-01-02/
2024-01-21 20:42:19      33338 pedidos-2024-01-02.csv.gz
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $
```

### Execute do crawler `crawler_pedidos`
1. Na página de crawlers, selecione o crawler `crawler_pedidos` e clique em **Run** no topo à direita da página.

    > ### Atenção!
    > O status do crawler ficará em **Running** por cerca de 3 minutos. Ao final do processamento o status mudará para **Ready**

### Inspecione novamente a tabela `pedidos_part`
1. No painel lateral (esquerdo), clique em Databases;
2. Clique no link do database `ecommerce`;
3. Na sessão `Tables`, clique em `pedidos_part`;
4. Clique na aba **Partitions**;
    > Repare que agora a tabela possui duas partições (data_pedido **2024-01-01** e **2024-01-02**);
5. Abra o AWS Athena e em um editor SQL digite a seguinte consulta:
```
SHOW PARTITIONS ecommerce.pedidos_part;
```

Output esperado:
```
data_pedido=2024-01-01
data_pedido=2024-01-02
```
6. Verifique o valor total de pedidos agrupados por dia:
```
SELECT data_pedido, sum(quantidade * valor_unitario) vl_total
FROM "ecommerce"."pedidos_part"
GROUP BY data_pedido
```

### Adicionando as demais partições

No terminal shell do Cloud9 execute os comandos a seguir.

1. Primeiro copiamos os arquivos para suas respectivas pastas de partição
```
echo "Fazendo upload dos arquivos para a pasta particionada"
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
```

2. Inicialize o crawler `crawler_pedidos`
```
aws glue start-crawler --name crawler_pedidos
```

3. Abra novamente o painel **Tables** do AWS Glue, clique na tabela `pedidos_part` e verifique a aba **Partitions**.

# Parabéns!
Concluímos que o Glue Crawler pode ser um aliado importante na automação de descoberta e atualização de metadados do Glue Catalog.

