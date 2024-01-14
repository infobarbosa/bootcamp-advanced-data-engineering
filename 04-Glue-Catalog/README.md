# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 04 - Glue 

O objetivo desta sessão é criar o banco de dados `ecommerce` no Glue Catalog.<br>
Há 3 opções para criação: via console AWS, via terminal e via CloudFormation.

## Via console AWS

1. No console AWS, acesse a barra de pesquisa e busque por Glue;
2. No painel lateral (esquerda), no menu **Data Catalog** clique em **Databases**;
3. Na tela que abrir clique em **Add database**;
4. No campo **Name** informe `ecommerce`;
5. No campo **Description** informe `Banco de dados da nossa empresa fictícia de e-commerce`.

## Via terminal Cloud9

Execute o comando a seguir no terminal:
```
aws glue create-database --database-input "{\"Name\":\"ecommerce\"}" 
```
O comando não produz output.<br>

Verifique se o banco de dados foi criado através do comando a seguir:
```
aws glue get-databases
```
Output:
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

## Via CloudFormation

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
