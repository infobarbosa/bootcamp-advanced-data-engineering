# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

## 05 - Athena (CSV)

O objetivo desta sessão é executar queries na tabela `pagamentos_raw` (baseada em arquivo **csv**)

### Primeira consulta
1. Na barra de pesquisa, busque por **Athena**.
2. No painel lateral (esquerdo), clique em **Query editor** (Editor de consultas).

    > ### Atenção!
    > Na primeira vez que você acessa o Athena é exibida a seguinte mensagem:
    > `Before you run your first query, you need to set up a query result location in Amazon S3.`
    > (`Antes de executar sua primeira consulta, é necessário definir um local para o resultado da consulta no Amazon S3.`)
    > - Clique em **Edit settings** (Editar configurações);
    > - Na tela **Manage settings** (Gerenciar configurações), para o campo **Query result location and encryption** clique no botão **Browse S3** (Navegue pelo S3)
    > - Na tela **Choose S3 data set** clique no link do bucket criado neste laboratório;
    > - Clique no radio button correspondente à pasta **results** e então clique no botão **Choose**;
    > - De volta à tela **Manage settings** clique no botão **Save**.
    > - Clique novamente em **Query editor** no painel lateral esquerdo;

3. No editor que estará disponível digite a seguinte consulta SQL:
    ```
    SELECT * FROM "bolsafamilia"."pagamentos_raw" limit 10;
    ```
4. Clique no botão **Run**
5. Verifique o resultado. Perceba a estrutura da tabela e seus dados.

### Consultas analíticas

Vamos fazer algumas consultas analíticas para nos familiarizar mais com o ambiente **Athena**

Primeiro, vamos contar a **quantidade de registros** há na tabela
```
SELECT count(1) qtt
FROM "bolsafamilia"."pagamentos_raw"
```

Agora vamos contar a **quantidade de NIS distintos** há na tabela
```
SELECT count(1) qtt_registros
    ,count(distinct nis) qtt_nis
FROM "bolsafamilia"."pagamentos_raw"
```

> Perceba a diferença entre a quantidade de CPF versus a quantidade de registros

Agova vamos somar o **valor total pago** pelo benefício:
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

Vamos analisar o **valor total pago agrupado por UF**:
```
SELECT uf
    ,format('%,.2f',sum(valor)) vl_total
    ,count(1) qtt_registros
    ,count(distinct nis) qtt_nis
FROM "bolsafamilia"."pagamentos_raw"
GROUP BY ROLLUP (uf)
ORDER BY sum(valor) DESC
```

Qual foi a UF que com maior volume financeiro recebido pelo benefício?

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