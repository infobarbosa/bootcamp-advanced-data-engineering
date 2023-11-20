Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 04 - Glue 

O objetivo desta sessão é criar a estrutura de dados no Glue Catalog e executar a ingestão de dados.

```
export bucket_name=[NOME DO SEU BUCKET AQUI]
export role_name=LabRole
export database_name=labdb
```

```
aws glue create-database --database-input "{\"Name\":\"labdb\"}"
```


aws glue create-crawler \
--name ${bucket_name} \
--role ${role_name} \
--database-name ${database_name} \
--table-prefix bolsafamilia_ \
--targets "{\"S3Targets\": [{\"Path\": \"s3://${BUCKET_NAME}/raw/lab1/csv\"} ]}"