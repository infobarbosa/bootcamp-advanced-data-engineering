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

2. Navegue para o diretório `assets\data`
```
cd 03-Datasets/assets/data/
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ cd 03-Datasets/assets/data/
voclabs:~/environment/bootcamp-advanced-data-engineering/03-Datasets/assets/data (main) $ 
```

3. Execute o comando a seguir 
```
aws s3 cp clientes.csv s3://lab-data-eng-202312-p4004/raw/ecommerce/clientes/ 
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

2. Navegue para o diretório `assets\data`
```
cd 03-Datasets/assets/data/
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ cd 03-Datasets/assets/data/
voclabs:~/environment/bootcamp-advanced-data-engineering/03-Datasets/assets/data (main) $ 
```

3. Execute o comando a seguir 
```
aws s3 cp . s3://lab-data-eng-202312-p4004/raw/ecommerce/pedidos/ --recursive --exclude "*" --include "pedidos*"
```

4. Confira se o upload ocorreu como esperado:
```
aws s3 ls s3://lab-data-eng-202312-p4004/raw/ecommerce/pedidos/
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering/03-Datasets/assets/data (main) $ aws s3 ls s3://lab-data-eng-202312-p4004/raw/ecommerce/pedidos/
2024-01-07 21:15:30          0 
2024-01-07 22:17:11      37631 pedidos-2024-01-01.txt
2024-01-07 22:17:11      37759 pedidos-2024-01-02.txt
2024-01-07 22:17:11      37707 pedidos-2024-01-03.txt
2024-01-07 22:17:11      37669 pedidos-2024-01-04.txt
2024-01-07 22:17:11      37654 pedidos-2024-01-05.txt
2024-01-07 22:17:11      37681 pedidos-2024-01-06.txt
2024-01-07 22:17:11      37666 pedidos-2024-01-07.txt
2024-01-07 22:17:11      37693 pedidos-2024-01-08.txt
2024-01-07 22:17:11      37680 pedidos-2024-01-09.txt
2024-01-07 22:17:11      37677 pedidos-2024-01-10.txt
2024-01-07 22:17:11      37728 pedidos-2024-01-11.txt
2024-01-07 22:17:11      37690 pedidos-2024-01-12.txt
2024-01-07 22:17:11      37627 pedidos-2024-01-13.txt
2024-01-07 22:17:11      37630 pedidos-2024-01-14.txt
2024-01-07 22:17:11      37658 pedidos-2024-01-15.txt
2024-01-07 22:17:11      37685 pedidos-2024-01-16.txt
2024-01-07 22:17:11      37630 pedidos-2024-01-17.txt
2024-01-07 22:17:11      37673 pedidos-2024-01-18.txt
2024-01-07 22:17:11      37648 pedidos-2024-01-19.txt
2024-01-07 22:17:11      37690 pedidos-2024-01-20.txt
2024-01-07 22:17:11      37677 pedidos-2024-01-21.txt
2024-01-07 22:17:11      37702 pedidos-2024-01-22.txt
2024-01-07 22:17:11      37623 pedidos-2024-01-23.txt
2024-01-07 22:17:11      37597 pedidos-2024-01-24.txt
2024-01-07 22:17:11      37653 pedidos-2024-01-25.txt
2024-01-07 22:17:11      37626 pedidos-2024-01-26.txt
2024-01-07 22:17:11      37679 pedidos-2024-01-27.txt
2024-01-07 22:17:11      37688 pedidos-2024-01-28.txt
2024-01-07 22:17:11      37651 pedidos-2024-01-29.txt
2024-01-07 22:17:11      37690 pedidos-2024-01-30.txt
2024-01-07 22:17:11      37669 pedidos-2024-01-31.txt
voclabs:~/environment/bootcamp-advanced-data-engineering/03-Datasets/assets/data (main) $ 
```

Se tudo estiver correto então você verá 31 arquivos referentes a pedidos entre 01/01/2024 a 31/01/2024.