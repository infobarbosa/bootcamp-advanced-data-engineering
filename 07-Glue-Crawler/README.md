# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 07 - Glue Crawler

O objetivo desta sessão é apresentar o Glue Crawler como ferramenta de descoberta de dados e metadados.<br>
No exercício **04-Glue-Catalog**, nós criamos as tabelas `clientes` e `pedidos` com base em definições pré-estabelecidas. O que acontece quando temos um dataset para o qual não temos uma definição sobre os metadados do seu conteúdo?<br>
Já no exercício anterior, **06-Tabelas-Particionadas**, adicionamos partições manualmente via comando `ALTER TABLE ADD PARTITION`.<br>
No dia-a-dia esse processo manual é inviável então uma automação se torna necessária.<br>

Neste exercício faremos algo simples, criação de tabela e adição de partições. Porém, o Glue Crawler possui várias possibilidades de conexão a sistemas de armazenamento (S3, bancos de dados relacionais, etc.) para determinar alterações de estrutura (schema) e então criar ou atualizar metadados de tabelas no catálogo de dados (Glue Catalog).


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

---
## Pedidos
---
### Crie o crawler `pedidos_crawler`
1. No console AWS, acesse a barra de pesquisa e busque por Glue;
2. No painel lateral (esquerda), abaixo de **Databases**, clique em **Tables**;
3. Na tela que se abrir clique no botão **Add tables using crawler**;
4. Em **name**, digite `pedidos_crawler`;
5. Clique no botão **Next** ao final da página;
6. Clique em **Add a data source**
    - Em **Data source** escolha S3
    - Em **Location of S3 data** mantenha `In this account`
    - Em **S3 path** informe `s3://[SEU BUCKET AQUI]/raw/ecommerce/pedidos/part` ajustando para o nome do seu bucket.
    - Mantenha as demais configurações inalteradas
    - Clique no botão **Add an S3 data source** ao final da página
7. De volta à tela **Choose data sources and classifiers** clique no botão `Next` ao final da página;
8. Na tela **Configure security settings**, em **IAM Role** escolha `LabRole`;
9. Clique no botão **Next** ao final da página;
10. Na tela **Set output and scheduling**, em **Target database** escolha `ecommerce`;
11. Deixe o campo **Table name prefix** vazio;
12. Em **Crawler schedule**, no campo **Frequency** mantenha `On demand` ;
13. Clique no botão **Next** ao final da página;
13. Na tela `Review and create`, revise as configurações e então clique em `Create crawler` ao final da página.

Você então receberá a mensagem a seguir no topo da tela:
```
One crawler successfully created
The following crawler is now created: "pedidos_crawler"
```

### Execute do crawler `pedidos_crawler`
1. Na página de crawlers, selecione o crawler `pedidos_crawler` e clique em `Run` no topo à direita da página

    > ### Atenção!
    > O status do crawler ficará em **Running** por cerca de 3 minutos. Ao final do processamento o status mudará para **Ready**

### Inspecione a tabela `pedidos`
Se tudo ocorreu como esperado, o crawler criará uma tabela `pedidos`.
1. No painel lateral (esquerdo), clique em Databases;
2. Clique no link do database `ecommerce`;
3. Na sessão `Tables`, clique em `pedidos`

Agora você pode revisar os metadados criados pelo crawler.


Agora você pode revisar os metadados criados pelo crawler.


## Via CloudFormation + terminal Cloud9

> ### Atenção! 
> Nesta etapa você precisará editar o arquivo `gluecrawler.cf.yml`

Abra o arquivo `assets/gluecrawler.cf.yml`. 
- Altere o valor do parâmetro `BucketURI` para a URI do bucket S3 criado no laboratório. Ex.: s3://data-science-bucket--6082f1d0/raw/
- Altere o valor do parâmetro `RoleARN` para a ARN da Role utilizada no laboratório. Ex.: arn:aws:iam::9876543210:role/LabRole

Validando o script cloudformation:
```
aws cloudformation validate-template --template-body file://assets/gluecrawler.cf.yml
```

Execute o script cloudformation:
```
aws cloudformation create-stack --stack-name gluecrawler --template-body file://gluecrawler.cf.yml --capabilities CAPABILITY_NAMED_IAM
```



## Via AWS CLI + terminal Cloud9

#### Variáveis de ambiente
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

#### Crie o crawler
```
aws glue create-crawler \
--name pedidos_crawler \
--role ${ROLE_NAME} \
--database-name ${DATABASE_NAME} \
--table-prefix pedidos_ \
--targets "{\"S3Targets\": [{\"Path\": \"s3://${BUCKET_NAME}/raw/ecommerce/pedidos/part/\"} ]}"
```