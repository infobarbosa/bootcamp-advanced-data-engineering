# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 20 - Desafio

Este desafio tem por objetivo testar seus conhecimentos a partir do que exercitou nos laboratórios anteriores.<br>
Passo-a-passo:
1. Crie a pasta `raw/bolsafamilia/pagamentos` no bucket S3 criado neste bootcamp
    - Utilize o conhecimento adquirido no exercício **02-Bucket-S3**;
    - Perceba que criaremos **apenas o database**, sem tabelas.
2. Faça o upload dos arquivos `202303_NovoBolsaFamilia_[UF].csv.gz` para o bucket no S3 na pasta `raw/bolsafamilia/pagamentos`.
    - Os arquivos estão na pasta `20-Desafio/assets/data`;
    - Utilize o conhecimento adquirido no exercício **02-Bucket-S3**.
    ```
    aws s3 cp 20-Desafio/assets/data/ s3://${BUCKET_NAME}/raw/bolsafamilia/pagamentos/ --recursive --exclude "*" --include "202311_NovoBolsaFamilia_*.csv.gz"
    ```

3. Crie o database `bolsafamilia` no **Glue Catalog**;
    - Utilize o conhecimento adquirido no exercício **04-Glue-Catalog**.
4. Crie o Glue Crawler `crawler_pagamentos`;
    - Utilize o conhecimento adquirido no exercício **07-Glue-Crawler**;
    - Utilize o procedimento que aplicamos para criação do crawler `crawler_clientes`;
    - Utilize o bucket S3 e path criados no item 1 desse desafio (`raw/bolsafamilia/pagamentos`);
    - Utilize o database `bolsafamilia`;
    - Utilize o prefixo `raw_`;
    - Utilize a role `LabRole`.

5. Execute o Glue Crawler `crawler_pagamentos`;
6. Verifique os metadados da tabela `raw_pagamentos`;
7. Faça consultas na tabela `raw_pagamentos` via **AWS Athena**:
    -  Utilize o conhecimento adquirido no exercício **05-Athena**.
6.a. Primeiro, vamos contar a **quantidade de registros** há na tabela
```
SELECT count(1) qtt
FROM "bolsafamilia"."raw_pagamentos"
```

6.b. Agora vamos contar a **quantidade de NIS distintos** há na tabela
```
SELECT count(distinct nis) qtt_nis
FROM "bolsafamilia"."raw_pagamentos"
```

> Perceba a diferença entre a quantidade de CPF versus a quantidade de registros

6.c. Agova vamos somar o **valor total pago** pelo benefício:
```
SELECT sum(valor) vl_total
    ,count(1) qtt_registros
    ,count(distinct nis) qtt_nis
FROM "bolsafamilia"."raw_pagamentos"
```

> Perceba que o valor aparece em notação exponencial.
> Vamos contornar isso com a função `format`

```
SELECT format('%,.2f',sum(valor)) vl_total
    ,count(1) qtt_registros
    ,count(distinct cpf) qtt_cpf
FROM "bolsafamilia"."raw_pagamentos"
```

6.d. Vamos analisar o **valor total pago agrupado por UF**:
```
SELECT uf
    ,format('%,.2f',sum(valor)) vl_total
    ,count(1) qtt_registros
    ,count(distinct nis) qtt_nis
FROM "bolsafamilia"."raw_pagamentos"
GROUP BY ROLLUP (uf)
ORDER BY sum(valor) DESC
```

6.e. Qual foi a UF que com maior volume financeiro recebido pelo benefício?

Se ordenarmos pelo número de beneficiários, qual o resultado?
```
SELECT uf
    ,format('%,.2f',sum(valor)) vl_total
    ,count(1) qtt_registros
    ,count(distinct nis) qtt_nis
FROM "bolsafamilia"."raw_pagamentos"
GROUP BY ROLLUP (uf)
ORDER BY count(nis) DESC
```