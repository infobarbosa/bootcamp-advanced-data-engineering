# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 30 - Kinesis

O objetivo desta sessão é executar operações de extração, transformação e carga (ETL) utilizando o Glue Job utilizando o Kinesis Data Streams como fonte de dados.

## Parte 1 - Preparação da stream e função lambda
### 1o. passo - Criando a stream `pedidos`
```
aws kinesis create-stream --stream-name pedidos --shard-count 1
```

### 2o. passo - Instalando a função lambda na AWS
1. Obtendo o ARN da role:
> Atenção! Substitua `LabRole` pelo nome da role que você tem disponível na sua conta.
```
export LAB_ROLE=$(aws iam get-role --role-name LabRole | jq '.Role.Arn' -r)
```

```
echo $LAB_ROLE
```

2. Crie uma nova função Lambda com o comando `aws lambda create-function`:
```
aws lambda create-function \
    --function-name gerador-pedidos \
    --zip-file fileb://../lambda/function.zip \
    --handler lambda_function.lambda_handler \
    --runtime python3.12 \
    --role $LAB_ROLE \
    --timeout 900
```

3. Se você já tem uma função Lambda e quer atualizá-la com um novo código, use o comando aws lambda update-function-code:
```
aws lambda update-function-code --function-name gerador-pedidos --zip-file fileb://../lambda/function.zip
```

Agora, sua função Lambda está pronta para ser usada na AWS.

### 3o. passo - Invocando a função lambda
```
aws lambda invoke --function-name gerador-pedidos out.json
```


## Parte 2 - Ingestão dos dados

# Working in progress...

---
###  Criando um job baseado em script

#### Variáveis de ambiente
```
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

2. `glue-job-pedidos-stream.py` 

```
aws s3 cp 30-Kinesis/assets/scripts/glue-job-pedidos-stream.py s3://${BUCKET_NAME}/scripts/ 
```

Conferindo:
```
aws s3 ls s3://${BUCKET_NAME}/scripts/glue-job-pedidos-stream.py 
```


#### Criando os jobs


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
