Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 04 - Glue 

O objetivo desta sessão é criar a estrutura de dados no Glue Catalog e executar a ingestão de dados.

## Via console AWS

### Crie o crawler `bolsafamilia_crawler1`
1. No console AWS, acesse a barra de pesquisa e busque por Glue
2. No painel lateral (esquerda), abaixo de `Databases`, clique em `Tables`
3. Na tela que se abrir clique em `Add tables using crawler`
4. Em `name`, digite `bolsafamilia_crawler1`
5. Clique no botão `Next` ao final da página
6. Clique em `Add a data source` 
    - Em `Data source` escolha S3
    - Em `Location of S3 data` mantenha `In this account`
    - Em `S3 path` informe `s3://[SEU BUCKET AQUI]/raw` ajustando para o nome do seu bucket.
    - Mantenha as demais configurações inalteradas
7. Clique no botão `Add an S3 data source` ao final da página
8. De volta à tela `Choose data sources and classifiers` clique no botão `Next` ao final da página
9. Na tela `Configure security settings`, em `IAM Role` escolha `LabRole`
10. Clique no botão `Next` ao final da página
11. Na tela `Set output and scheduling`, em `Target database` escolha `labdb`
12. No campo `Table name prefix`, digite `bolsafamilia_`
13. Em `Crawler schedule`, mantenha `On demand` no campo `Frequency`
14. Na tela `Review and create`, revise as configurações e então clique em `Create crawler` ao final da página.

Você então receberá a mensagem a seguir no topo da tela
```
One crawler successfully created
The following crawler is now created: "bolsafamilia_crawler1"
```

### Execute do crawler `bolsafamilia_crawler1`
1. Na página de crawlers, selecione o crawler `bolsafamilia_crawler1` e clique em `Run` no topo à direita da página

    > ### Atenção!
    > O status do crawler ficará em **Running** por cerca de 3 minutos. Ao final do processamento o status mudará para **Ready**

### Inspecione a tabela `bolsafamilia_raw`
Se tudo ocorreu como esperado, o crawler criará uma tabela `bolsafamilia_raw`.
1. No painel lateral (esquerdo), clique em Databases
2. Clique no link do database `labdb`
3. Na sessão `Tables`, clique em `bolsafamilia_raw`

Agora você pode revisar os metadados criados pelo crawler.


## Via terminal Cloud9

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




#### Variáveis de ambiente
```
export bucket_name=[NOME DO SEU BUCKET AQUI]
export role_name=LabRole
export database_name=labdb
```

#### Crie o database


```
aws glue create-database --database-input "{\"Name\":\"labdb\"}"
```

#### Crie o crawler
```
aws glue create-crawler \
--name ${bucket_name} \
--role ${role_name} \
--database-name ${database_name} \
--table-prefix bolsafamilia_ \
--targets "{\"S3Targets\": [{\"Path\": \"s3://${BUCKET_NAME}/raw/lab1/csv\"} ]}"
```