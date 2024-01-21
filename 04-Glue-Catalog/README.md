# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 04 - Glue 

O objetivo desta sessão é criar o banco de dados `ecommerce` no Glue Catalog.<br>
Há 3 opções para criação: via AWS CLI, via console AWS e via CloudFormation.

## Via terminal Cloud9

### Database `ecommerce`
1. Execute o comando a seguir no terminal:
```
aws glue create-database --database-input "{\"Name\":\"ecommerce\"}" 
```
O comando não produz output.<br>

2. Verifique se o banco de dados foi criado através do comando a seguir:
```
aws glue get-databases
```

Output esperado:
```
voclabs:~/environment $ aws glue get-databases
{
    "DatabaseList": [
        {
            "Name": "ecommerce",
            "CreateTime": "2024-01-13T14:44:29+00:00",
            "CreateTableDefaultPermissions": [
                {
                    "Principal": {
                        "DataLakePrincipalIdentifier": "IAM_ALLOWED_PRINCIPALS"
                    },
                    "Permissions": [
                        "ALL"
                    ]
                }
            ],
            "CatalogId": "966260589623"
        }
    ]
}
voclabs:~/environment $ 
```

### Tabela `clientes`
### <span style="color : red">ATENÇÃO!</span>
4. Edite o arquivo `clientes.json` para considerar o bucket criado no exercício **02-Bucket-S3**

5. Execute o comando de criação a seguir:
```
aws glue create-table --database-name ecommerce --table-input "file://04-Glue-Catalog/assets/scripts/clientes.json"
```

### Tabela `pedidos`
### <span style="color : red">ATENÇÃO!</span>
6. Edite o arquivo `pedidos.json` para considerar o bucket criado no exercício **02-Bucket-S3**

7. Execute o comando de criação a seguir:
```
aws glue create-table --database-name ecommerce --table-input "file://04-Glue-Catalog/assets/scripts/pedidos.json"
```

## [OPCIONAL] Via console AWS

1. No console AWS, acesse a barra de pesquisa e busque por Glue;
2. No painel lateral (esquerda), no menu **Data Catalog** clique em **Databases**;
3. Na tela que abrir clique em **Add database**;
4. No campo **Name** informe `ecommerce`;
5. No campo **Description** informe `Banco de dados da nossa empresa fictícia de e-commerce`.

## [OPCIONAL] Via CloudFormation

> ### Atenção! 
> Nesta etapa você precisará editar o arquivo `database.cf.yml`

Validando o script cloudformation:
```
aws cloudformation validate-template --template-body file://04-Glue-Catalog/assets/scripts/database.cf.yml
```

Execute o script cloudformation:
```
aws cloudformation create-stack --stack-name database-ecommerce --template-body file://04-Glue-Catalog/assets/scripts/database.cf.yml --capabilities CAPABILITY_NAMED_IAM
```


---

# Eliminando tabelas
Caso precise eliminar alguma tabela, você pode fazer isso via terminal com o seguinte comando:
```
aws glue delete-table --database-name ecommerce --name pedidos
```

```
aws glue delete-table --database-name ecommerce --name clientes
```