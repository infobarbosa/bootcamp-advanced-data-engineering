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

Diferente do que fizemos no crawler `crawler_clientes`, neste exercício pretende demonstrar como o crawler `crawler_pedidos` automatiza o processo de adição de partições na tabela `pedidos_part`.

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
15. Na tela **Set output and scheduling**, na sessão **Crawler schedule**, no combo **Frequency** mantenha `On demand` ;
16. Clique no botão **Next** ao final da página;
17. Na tela **Review and create**, revise as configurações e então clique em **Create crawler** ao final da página.

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
    > Repare que agora a tabela possui duas partições (data_pedido 2024-01-01 e 2024-01-02);
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

# Parabéns!
Concluímos que o Glue Crawler pode ser um aliado importante na automação de descoberta e atualização de metadados do Glue Catalog.

<br>
<br>

---

## [OPCIONAL] Via CloudFormation + terminal Cloud9

> ### Atenção! 
> - Nesta etapa você precisará editar o arquivo `gluecrawler-clientes.cf.yml`;<br>
> - O arquivo está na pasta `07-Glue-Crawler/assets/scripts/`;<br>
> - Utilize o editor do Cloud9.

1. Abra o arquivo `gluecrawler-clientes.cf.yml`. 
- Altere o valor do parâmetro `BucketURI` para a URI do bucket S3 criado no laboratório. Ex.: `s3://lab-data-eng-202402-p40041/raw/ecommerce/clientes/`;
- Altere o valor do parâmetro `RoleARN` para a ARN da Role utilizada no laboratório. Ex.: `arn:aws:iam::9876543210:role/LabRole`.

2. Valide o script cloudformation:
```
aws cloudformation validate-template --template-body file://07-Glue-Crawler/assets/scripts/gluecrawler-clientes.cf.yml
```

3. Execute o script cloudformation:
```
aws cloudformation create-stack --stack-name gluecrawler-clientes --template-body file://07-Glue-Crawler/assets/scripts/gluecrawler-clientes.cf.yml --capabilities CAPABILITY_NAMED_IAM
```
<br>
<br>

## [OPCIONAL] Via AWS CLI + terminal Cloud9

1. Variáveis de ambiente
```
export ROLE_NAME=LabRole
export DATABASE_NAME=ecommerce
```

```
export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')
```

```
echo ${BUCKET_NAME}
echo ${ROLE_NAME}
echo ${DATABASE_NAME}
```

2. Crie o crawler
```
aws glue create-crawler \
--name crawler_clientess \
--role ${ROLE_NAME} \
--database-name ${DATABASE_NAME} \
--table-prefix tb_crawler_ \
--targets "{\"S3Targets\": [{\"Path\": \"s3://${BUCKET_NAME}/raw/ecommerce/clientes/\"} ]}"
```
