# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 20 - Desafio

Este desafio tem por objetivo testar seus conhecimentos a partir do que exercitou nos laboratórios anteriores.<br>
Passo-a-passo:
1. Crie a pasta `raw/bolsafamilia/` no bucket S3 utilizado no exercício **02-Bucket-S3**
2. Faça o upload do arquivo `202303_NovoBolsaFamilia_utf-8.csv.gz` para o bucket no S3 na pasta `raw/bolsafamilia`.
    > O arquivo está na pasta `20-Desafio/assets/data`
3. Crie o database `bolsafamilia` no **Glue Catalog** 
    > Utilize o conhecimento adquirido no exercício **04-Glue-Catalog**
4. Crie o Glue Crawler `pagmentos_crawler`
    > Utilize o conhecimento adquirido no exercício **05-Glue-Crawler**
    > O database será o `bolsafamilia`
    > O nome da tabela será `pedidos_raw`
    > A role utilizada será `LabRole`
5. Verifique os metadados da tabela `pedidos_raw` 
6. Faça consultas na tabela `pedidos_raw` via AWS Athena:

6.a. Primeiro, vamos contar a **quantidade de registros** há na tabela
```
SELECT count(1) qtt
FROM "bolsafamilia"."pagamentos_raw"
```

6.b. Agora vamos contar a **quantidade de NIS distintos** há na tabela
```
SELECT count(1) qtt_registros
    ,count(distinct nis) qtt_nis
FROM "bolsafamilia"."pagamentos_raw"
```

> Perceba a diferença entre a quantidade de CPF versus a quantidade de registros

6.c. Agova vamos somar o **valor total pago** pelo benefício:
```
SELECT sum(valor) vl_total
    ,count(1) qtt_registros
    ,count(distinct nis) qtt_nis
FROM "bolsafamilia"."pagamentos_raw"
```

> Perceba que o valor aparece em notação exponencial.
> Vamos contornar isso com a função `format`

```
SELECT format('%,.2f',sum(valor)) vl_total
    ,count(1) qtt_registros
    ,count(distinct cpf) qtt_cpf
FROM "bolsafamilia"."pagamentos_raw"
```

6.d. Vamos analisar o **valor total pago agrupado por UF**:
```
SELECT uf
    ,format('%,.2f',sum(valor)) vl_total
    ,count(1) qtt_registros
    ,count(distinct nis) qtt_nis
FROM "bolsafamilia"."pagamentos_raw"
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
FROM "bolsafamilia"."pagamentos_raw"
GROUP BY ROLLUP (uf)
ORDER BY count(nis) DESC
```