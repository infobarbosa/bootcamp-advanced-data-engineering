# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 04 - Glue Catalog

O objetivo desta sessão é criar o banco de dados `ecommerce` no Glue Catalog.<br>
Há 3 opções para criação: via AWS CLI, via console AWS e via CloudFormation.<br>
Neste exercício priorizaremos **via terminal com AWS CLI**.

## Via terminal com AWS CLI

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

> Digite `Q` (quit) para sair do prompt do comando acima.

### Tabela `tb_raw_clientes`
### <span style="color : red">ATENÇÃO!</span>
3. Edite o arquivo `clientes.json` para considerar o bucket criado no exercício **02-Bucket-S3**
> - O arquivo está na pasta `04-Glue-Catalog/assets/scripts`;
> - Altere a tag **"Location"** no arquivo com o nome do seu bucket;
> - Utilize o editor do Cloud9

4. Execute o comando de criação a seguir:
```
aws glue create-table --database-name ecommerce --table-input "file://04-Glue-Catalog/assets/scripts/clientes.json"
```

### Tabela `tb_raw_pedidos`
### <span style="color : red">ATENÇÃO!</span>
5. Edite o arquivo `pedidos.json` para considerar o bucket criado no exercício **02-Bucket-S3**
> - O arquivo está na pasta `04-Glue-Catalog/assets/scripts`;
> - Altere a tag **"Location"** no arquivo com o nome do seu bucket;
> - Utilize o editor do Cloud9

6. Execute o comando de criação a seguir:
```
aws glue create-table --database-name ecommerce --table-input "file://04-Glue-Catalog/assets/scripts/pedidos.json"
```

7. Verifique se as tabelas foram criadas corretamente:
```
aws glue get-tables --database-name 'ecommerce'  --query "TableList[].Name"
```

```
aws glue get-tables --database-name 'ecommerce'  --query "TableList[].StorageDescriptor.Location"
```

8. [OPCIONAL] Caso você queira ver mais detalhes das tabelas criadas:
```
aws glue get-tables --database-name 'ecommerce'
```
> Digite `Q` (quit) para sair do prompt do comando acima.

---

# [OPCIONAL] Eliminando tabelas
> Atenção!<br>
> Esta sessão não é necessária para prossegumento do laboratório. Apenas elimine tabelas no caso da criação nos passos anteriores tenha falhado.

Caso precise eliminar alguma tabela, você pode fazer isso via terminal com o seguinte comando:
```
aws glue delete-table --database-name ecommerce --name tb_raw_pedidos
```

```
aws glue delete-table --database-name ecommerce --name tb_raw_clientes
```