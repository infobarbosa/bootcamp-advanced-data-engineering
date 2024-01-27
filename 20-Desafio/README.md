# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 20 - Desafio

Este desafio tem por objetivo testar seus conhecimentos a partir do que exercitou nos laboratórios anteriores.<br>

## Caso de uso
Vamos utilizar uma base de pagamentos do programa social **Novo Bolsa Família**, do Governo Federal.<br>
Os dados podem ser baixados livremente através do [Portal da Transparência](https://portaldatransparencia.gov.br/download-de-dados/novo-bolsa-familia).<br>

## O dataset
    
- A base de pagamentos será a de Novembro/2023;
- A base está disponível no diretório `20-Desafio/assets/data`;
- A base foi convertida de compressão `zip` para `gzip`;
- A base foi particionada por UF;
- O character set da base foi alterado de LATIN_1 para UTF-8;
- Os valores foram convertidos do padrão brasileiro (vírgula decimal) para o americano (ponto decimal);
- O header (cabeçalho) do arquivo foi tratado retirando acentuações e espaços;
- O conteúdo da base (valores, municípios e beneficiários) permanece fiel ao disponibilizado pelo **Portal da Transparência**. Ou seja, não foram adicionados, removidos ou alterados registros nem alterado qualquer valor;
- O projeto utilizado para os tratamentos acima pode ser encontrado [aqui](https://github.com/infobarbosa/bolsafamilia_conversor_utf-8).

Abaixo segue uma pequena amostra do conteúdo de um dos arquivos:
```
MES_COMPETENCIA;MES_REFERENCIA;UF;CODIGO_MUNICIPIO_SIAFI;MUNICIPIO;CPF;NIS;FAVORECIDO;VALOR
202311;202303;SP;3055;ITAPIRAPUA PAULISTA;***.081.588-**;20128077306;ADRIANE DE JESUS SANTOS;750.0
202311;202303;SP;6739;MORRO AGUDO;***.086.753-**;16358953061;MARIA DO ROSARIO GOMES DE MELO;650.0
202311;202303;SP;7107;SAO PAULO;***.523.498-**;13622350775;ADRIANA SANTOS;325.0
202311;202303;SP;7107;SAO PAULO;***.330.168-**;20732189858;DANIELA OLIVEIRA DOS SANTOS;950.0
```

Agora formatado:
```
MES_COMPETENCIA MES_REFERENCIA  UF  CODIGO_MUNICIPIO_SIAFI  MUNICIPIO           CPF             NIS	        FAVORECIDO                      VALOR
202311          202303          SP  3055                    ITAPIRAPUA PAULISTA ***.081.588-**  20128077306	ADRIANE DE JESUS SANTOS         750.0
202311          202303          SP  6739                    MORRO AGUDO         ***.086.753-**  16358953061	MARIA DO ROSARIO GOMES DE MELO  650.0
202311          202303          SP  7107                    SAO PAULO           ***.523.498-**  13622350775	ADRIANA SANTOS                  325.0
202311          202303          SP  7107                    SAO PAULO           ***.330.168-**  20732189858	DANIELA OLIVEIRA DOS SANTOS     950.0
```

## Passo-a-passo
1. Crie a pasta `raw/bolsafamilia/pagamentos` no bucket S3 criado neste bootcamp
    - Utilize o conhecimento adquirido no exercício **02-Bucket-S3**;
    - Perceba que criaremos **apenas o database**, sem tabelas.
2. Faça o upload dos arquivos `202303_NovoBolsaFamilia_[UF].csv.gz` para o bucket no S3 na pasta `raw/bolsafamilia/pagamentos`;
    - Os arquivos estão na pasta `20-Desafio/assets/data`;
    - Utilize o conhecimento adquirido no exercício **03-Datasets**.
    - Não esqueça de exportar a variável de ambiente BUCKET_NAME;
    - Utilize o comando a seguir para o upload:
    ```
    aws s3 cp 20-Desafio/assets/data/ s3://${BUCKET_NAME}/raw/bolsafamilia/pagamentos/ --recursive --exclude "*" --include "202311_NovoBolsaFamilia_*.csv.gz"
    ```
    - Não esqueça de conferir se todos os arquivos foram carregados corretamente na pasta `raw/bolsafamilia/pagamentos`.

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
    - Utilize o menu AWS Glue > Tables;
7. Faça consultas na tabela `raw_pagamentos` via **AWS Athena**:
    -  Utilize o conhecimento adquirido no exercício **05-Athena**.

    ##### 7.1 - Quantidade de registros
    ```
    SELECT count(1) qtt
    FROM "bolsafamilia"."raw_pagamentos"
    ```
    Qual a quantidade de registros da tabela?

    ##### 7.2 - Quantidade de NIS distintos
    ```
    SELECT count(distinct nis) qtt_nis
    FROM "bolsafamilia"."raw_pagamentos"
    ```
    Quantos NIS distintos há na tabela?
    
    > Perceba a diferença entre a quantidade de NIS versus a quantidade de registros

    ##### 7.3 - Valor total pago
    ```
    SELECT sum(valor) vl_total
    FROM "bolsafamilia"."raw_pagamentos"
    ```

    > Perceba que o valor aparece em notação exponencial.<br>
    > Vamos contornar isso com a função `format`

    ```
    SELECT format('%,.2f',sum(valor)) vl_total
    FROM "bolsafamilia"."raw_pagamentos"
    ```
    Qual o valor total pago pelo benefício?

    ##### 7.4 - Valor total pago agrupado por UF
    ```
    SELECT uf
        ,format('%,.2f',sum(valor)) vl_total
        ,count(1) qtt_registros
        ,count(distinct nis) qtt_nis
    FROM "bolsafamilia"."raw_pagamentos"
    GROUP BY ROLLUP (uf)
    ORDER BY sum(valor) DESC
    ```
    Qual o valor total pago agrupado por UF?

    ##### 7.5 - UF com maior volume financeiro recebido 

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
    Qual foi a UF que com maior volume financeiro recebido pelo benefício?

8. Crie um Glue Job baseado em notebook
    - Utilize o conhecimento adquirido no exercício **08-Glue-Job**;
    - Utilize o notebook `glue-job-desafio.ipynb` disponibilizado na pasta `20-Desafio/assets/notebook/`;
    - Após criar Glue Job no console AWS, siga as instruções contidas no notebook.