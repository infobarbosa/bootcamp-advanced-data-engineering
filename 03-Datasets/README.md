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

```

3. Execute o comando a seguir 
```
aws s3 cp 03-Datasets/assets/data/clientes.csv s3://lab-data-eng-202312-p4004/raw/ecommerce/clientes/ 
```

4. Confira se o upload ocorreu como esperado:
```
aws s3 ls s3://lab-data-eng-202312-p4004/raw/ecommerce/clientes/
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering/03-Datasets/assets/data (main) $ aws s3 ls s3://lab-data-eng-202312-p4004/raw/ecommerce/clientes/
2024-01-07 22:34:18    1066214 clientes.csv
voclabs:~/environment/bootcamp-advanced-data-engineering/03-Datasets/assets/data (main) $ 
```

Se tudo estiver ok então você verá apenas um arquivo `clientes.csv`

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

```

3. Para o upload execute o comando a seguir :
```
aws s3 cp 03-Datasets/assets/data/ s3://lab-data-eng-202312-p4004/raw/ecommerce/pedidos/ --recursive --exclude "*" --include "pedidos*"
```

4. Confira se o upload ocorreu como esperado:
```
aws s3 ls s3://lab-data-eng-202312-p4004/raw/ecommerce/pedidos/
```

Output esperado:
```

```

Se tudo estiver correto então você verá 31 arquivos referentes a pedidos entre 01/01/2024 a 31/01/2024.