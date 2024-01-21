# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

## 06 - Glue ETL

O objetivo desta sessão é executar operações de extração, transformação e carga (ETL) utilizando o Glue Job

### Criando um job baseado em notebook
1. Na barra de pesquisa, busque por **Glue** a seguir clique em **AWS Glue**;
2. No painel lateral (esquerdo), abaixo de **ETL Jobs**, clique em **Notebooks**;
3. Na tela **AWS Glue Studio**, na sessão **Create job**, clique em **Notebook**;
4. No tela sobreposta **Notebook** que se abrir:
    - No combo **Engine** mantenha **Spark (Python)**;
    - No menu de seleção **Options** escolha **Upload Notebook**;
    - Clique no botão **Choose file**;
    - Escolha o arquivo `glue-job-pedidos.ipynb` e faça o upload;
    - No combo **IAM Role**, escolha a role disponível (normalmente o nome é **LabRole**);
    - Clique no botão **Create notebook**.
5. No topo superior esquerdo clique em **Untitled job**, apague o conteúdo e digite `pedidos parquet` e pressione a tecla Enter;

A partir desse ponto você deve seguir as instruções contidas no notebook.
> Atenção!<br>
> Caso você não tenha familiaridade com o uso de notebooks, leia atentamente as instruções no início do notebook que acabou de abrir.

<br>

---
### [OPCIONAL] Criando um job baseado em script

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

#### Upload dos scripts
1. `glue-job-clientes.py`
```
aws s3 cp 08-Glue-Job/assets/scripts/glue-job-clientes.py s3://${BUCKET_NAME}/scripts/ 
```

Conferindo:
```
aws s3 ls s3://${BUCKET_NAME}/scripts/glue-job-clientes.py 
```


2. `glue-job-pedidos.py` 

```
aws s3 cp 08-Glue-Job/assets/scripts/glue-job-pedidos.py s3://${BUCKET_NAME}/scripts/ 
```

Conferindo:
```
aws s3 ls s3://${BUCKET_NAME}/scripts/glue-job-pedidos.py 
```


#### Criando os jobs
1. Clientes
```
aws glue create-job \
    --name clientes-job \
    --role ${ROLE_NAME} \
    --command '{ \
        "Name": "pythonshell", \
        "ScriptLocation": "s3://${BUCKET_NAME}/scripts/glue-job-clientes.py" \
    }' \
    --output json
```

2. Pedidos
```
aws glue create-job \
    --name pedidos-job \
    --role ${ROLE_NAME} \
    --command '{ \
        "Name": "pythonshell", \
        "ScriptLocation": "s3://${BUCKET_NAME}/scripts/glue-job-pedidos.py" \
    }' \
    --output json
```

#### Executando os jobs
1. Clientes
```
aws glue start-job-run --job-name clientes-job
```

2. Pedidos
```
aws glue start-job-run --job-name pedidos-job
```
