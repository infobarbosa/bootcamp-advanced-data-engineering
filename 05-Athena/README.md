# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

## 05 - Athena

O objetivo desta sessão é executar queries na tabela `bolsafamilia_raw`

### Primeira consulta
1. Na barra de pesquisa, busque por `Athena`.
2. No painel lateral (esquerdo), clique em `Query editor`.

    > ### Atenção!
    > Na primeira vez que você acessa o Athena é exibida a seguinte mensagem:
    > `Before you run your first query, you need to set up a query result location in Amazon S3.`
    > - Clique em `Edit settings`
    > - Na tela `Manage settings`, para o campo `Query result location and encryption` clique no botão `Browse S3`
    > - Na tela `Choose S3 data set` clique no link do bucket criado neste laboratório.
    > - Clique no radio button correspondente à pasta `results` e então clique no botão `Choose`
    > - De volta à tela `Manage settings` clique no botão `Save`

3. Clique novamente em `Query editor` (painel lateral)
4. No editor que estará disponível digite a seguinte consulta SQL:
    ```
    SELECT * FROM "labdb"."bolsafamilia_raw" limit 10;
    ```
5. Clique no botão `Run`
6. Verifique o resultado. Perceba a estrutura da tabela e seus dados.

### Consultas analíticas

Vamos fazer algumas consultas analíticas para nos familiarizar mais com o ambiente **Athena**

Primeiro, vamos contar quantos registros há na tabela
```
SELECT count(1) qtt
FROM "labdb"."bolsafamilia_raw"
```

Agora vamos contar quandos NIS distintos há na tabela
```
SELECT count(1) qtt_registros
    ,count(distinct nis) qtt_nis
FROM "labdb"."bolsafamilia_raw"
```

> Perceba a diferença entre a quantidade de CPF versus a quantidade de registros

Agova vamos somar o valor total pago pelo benefício:
```
SELECT sum(valor) vl_total
    ,count(1) qtt_registros
    ,count(distinct nis) qtt_nis
FROM "labdb"."bolsafamilia_raw"
```

> Perceba que o valor aparece em notação exponencial.
> Vamos contornar isso com a função `format`

```
SELECT format('%,.2f',sum(valor)) vl_total
    ,count(1) qtt_registros
    ,count(distinct cpf) qtt_cpf
FROM "labdb"."bolsafamilia_raw"
```

Vamos analisar os gastos do benefício por UF:
```
SELECT uf
    ,format('%,.2f',sum(valor)) vl_total
    ,count(1) qtt_registros
    ,count(distinct nis) qtt_nis
FROM "labdb"."bolsafamilia_raw"
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
FROM "labdb"."bolsafamilia_raw"
GROUP BY ROLLUP (uf)
ORDER BY count(nis) DESC
```