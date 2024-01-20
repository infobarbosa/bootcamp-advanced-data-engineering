# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 03 - Bases de dados

O objetivo desta sessão é obter os datasets (bases de dados) necessários à execução do laboratório.
## Bases de Clientes
1. Certifique-se que está no diretório do projeto:
```
pwd
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ pwd
/home/ubuntu/environment/bootcamp-advanced-data-engineering
```
> Atenção!
> Caso não esteja no diretório `/home/ubuntu/environment/bootcamp-advanced-data-engineering`, você pode navegar até ele através do comando:
> ```
> cd /home/ubuntu/environment/bootcamp-advanced-data-engineering
> ```

2. Liste os arquivos disponíveis em `assets\data`
```
ls -la 03-Datasets/assets/data/clientes*
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ ls -la 03-Datasets/assets/data/clientes*
-rw-rw-r-- 1 ubuntu ubuntu 329123 Jan 14 15:38 03-Datasets/assets/data/clientes.csv.gz
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ 
```

3. Vamos criar uma variável de ambiente `BUCKET_NAME`
```
export BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')
```

```
echo $BUCKET_NAME
```

4. Executando o upload
```
aws s3 cp 03-Datasets/assets/data/clientes.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/clientes/ 
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ aws s3 cp 03-Datasets/assets/data/clientes.csv.gz s3://${BUCKET_NAME}/raw/ecommerce/clientes/
upload: 03-Datasets/assets/data/clientes.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/clientes/clientes.csv.gz
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ 
```

5. Confira se o upload ocorreu como esperado:
```
aws s3 ls s3://${BUCKET_NAME}/raw/ecommerce/clientes/
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ aws s3 ls s3://${BUCKET_NAME}/raw/ecommerce/clientes/
2024-01-14 15:50:12     329123 clientes.csv.gz
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ 
```

Se tudo estiver ok então você verá apenas um arquivo `clientes.csv.gz`

## Bases de Pedidos

1. Certifique-se que está no diretório do projeto:
```
pwd
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ pwd
/home/ubuntu/environment/bootcamp-advanced-data-engineering
```
> Atenção!
> Caso não esteja no diretório `/home/ubuntu/environment/bootcamp-advanced-data-engineering`, você pode navegar até ele através do comando:
> ```
> /home/ubuntu/environment/bootcamp-advanced-data-engineering
> ```

2. Liste os arquivos disponíveis em `assets\data`
```
ls -la 03-Datasets/assets/data/pedidos*
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ ls -la 03-Datasets/assets/data/pedidos*
-rw-rw-r-- 1 ubuntu ubuntu 33306 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-01.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33338 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-02.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33284 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-03.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33257 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-04.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33282 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-05.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33347 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-06.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33294 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-07.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33279 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-08.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33315 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-09.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33291 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-10.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33316 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-11.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33275 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-12.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33295 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-13.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33299 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-14.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33245 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-15.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33273 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-16.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33235 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-17.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33267 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-18.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33333 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-19.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33324 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-20.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33264 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-21.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33293 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-22.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33331 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-23.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33302 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-24.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33243 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-25.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33298 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-26.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33311 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-27.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33342 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-28.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33264 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-29.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33357 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-30.csv.gz
-rw-rw-r-- 1 ubuntu ubuntu 33315 Jan 14 19:16 03-Datasets/assets/data/pedidos-2024-01-31.csv.gz
```

3. Para o upload execute o comando a seguir :
```
aws s3 cp 03-Datasets/assets/data/ s3://${BUCKET_NAME}/raw/ecommerce/pedidos/ --recursive --exclude "*" --include "pedidos*"
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ aws s3 cp 03-Datasets/assets/data/ s3://${BUCKET_NAME}/raw/ecommerce/pedidos/ --recursive --exclude "*" --include "pedidos*"
upload: 03-Datasets/assets/data/pedidos-2024-01-01.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-01.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-04.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-04.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-03.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-03.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-06.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-06.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-05.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-05.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-07.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-07.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-09.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-09.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-12.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-12.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-11.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-11.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-02.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-02.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-08.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-08.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-14.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-14.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-17.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-17.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-10.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-10.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-16.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-16.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-15.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-15.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-22.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-22.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-19.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-19.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-18.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-18.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-20.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-20.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-13.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-13.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-21.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-21.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-31.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-31.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-24.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-24.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-28.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-28.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-30.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-30.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-23.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-23.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-25.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-25.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-27.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-27.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-26.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-26.csv.gz
upload: 03-Datasets/assets/data/pedidos-2024-01-29.csv.gz to s3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/pedidos-2024-01-29.csv.gz
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ 
```

4. Confira se o upload ocorreu como esperado:
```
aws s3 ls s3://${BUCKET_NAME}/raw/ecommerce/pedidos/
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ aws s3 ls s3://${BUCKET_NAME}/raw/ecommerce/pedidos/
2024-01-14 19:22:01      33306 pedidos-2024-01-01.csv.gz
2024-01-14 19:22:01      33338 pedidos-2024-01-02.csv.gz
2024-01-14 19:22:01      33284 pedidos-2024-01-03.csv.gz
2024-01-14 19:22:01      33257 pedidos-2024-01-04.csv.gz
2024-01-14 19:22:01      33282 pedidos-2024-01-05.csv.gz
2024-01-14 19:22:01      33347 pedidos-2024-01-06.csv.gz
2024-01-14 19:22:01      33294 pedidos-2024-01-07.csv.gz
2024-01-14 19:22:01      33279 pedidos-2024-01-08.csv.gz
2024-01-14 19:22:01      33315 pedidos-2024-01-09.csv.gz
2024-01-14 19:22:01      33291 pedidos-2024-01-10.csv.gz
2024-01-14 19:22:01      33316 pedidos-2024-01-11.csv.gz
2024-01-14 19:22:01      33275 pedidos-2024-01-12.csv.gz
2024-01-14 19:22:01      33295 pedidos-2024-01-13.csv.gz
2024-01-14 19:22:01      33299 pedidos-2024-01-14.csv.gz
2024-01-14 19:22:01      33245 pedidos-2024-01-15.csv.gz
2024-01-14 19:22:01      33273 pedidos-2024-01-16.csv.gz
2024-01-14 19:22:01      33235 pedidos-2024-01-17.csv.gz
2024-01-14 19:22:01      33267 pedidos-2024-01-18.csv.gz
2024-01-14 19:22:01      33333 pedidos-2024-01-19.csv.gz
2024-01-14 19:22:01      33324 pedidos-2024-01-20.csv.gz
2024-01-14 19:22:01      33264 pedidos-2024-01-21.csv.gz
2024-01-14 19:22:01      33293 pedidos-2024-01-22.csv.gz
2024-01-14 19:22:01      33331 pedidos-2024-01-23.csv.gz
2024-01-14 19:22:01      33302 pedidos-2024-01-24.csv.gz
2024-01-14 19:22:01      33243 pedidos-2024-01-25.csv.gz
2024-01-14 19:22:01      33298 pedidos-2024-01-26.csv.gz
2024-01-14 19:22:01      33311 pedidos-2024-01-27.csv.gz
2024-01-14 19:22:01      33342 pedidos-2024-01-28.csv.gz
2024-01-14 19:22:01      33264 pedidos-2024-01-29.csv.gz
2024-01-14 19:22:01      33357 pedidos-2024-01-30.csv.gz
2024-01-14 19:22:01      33315 pedidos-2024-01-31.csv.gz
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ 
```

Se tudo estiver correto então você verá 31 arquivos referentes a pedidos entre 01/01/2024 a 31/01/2024.