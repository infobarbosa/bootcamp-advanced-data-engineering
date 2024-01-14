# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

## 05 - Athena

O objetivo desta sessão é executar queries nas tabelas baseadas em arquivos csv criadas nos exercícios anteriores.

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
    SELECT * FROM "ecommerce"."clientes" limit 10;
    ```
4. Clique no botão **Run**
5. Verifique o resultado. Perceba a estrutura da tabela e seus dados.
6. Faça o mesmo para a tabela `pedidos`:
    ```
    SELECT * FROM "ecommerce"."pedidos" limit 10;
    ```

### Consultas analíticas

Vamos fazer algumas consultas analíticas para nos familiarizar mais com o ambiente **Athena**

Primeiro, vamos contar a **quantidade de registros** há nas tabelas

Quantos clientes temos na base?
```
SELECT count(1) qtt
FROM "ecommerce"."clientes"
```

E quantos pedidos?
```
SELECT count(1) qtt
FROM "ecommerce"."pedidos"
```

Agora vamos contar a **quantidade de clientes distintos** que realizaram pedidos no dia **02/01/2024**
```
SELECT count(distinct id_cliente) qtt_clientes
      ,count(1) qtt_registros
FROM "ecommerce"."pedidos"
```

> Perceba a diferença entre a quantidade de clientes versus a quantidade de registros

Agova vamos somar o **valor total pago** pelo benefício:
```
SELECT sum(quantidade * valor_unitario) vl_total
FROM "ecommerce"."pedidos"
```

> Perceba que o valor aparece em notação exponencial.
> Vamos contornar isso com a função `format`

```
SELECT format('%,.2f',sum(quantidade * valor_unitario)) vl_total
FROM "ecommerce"."pedidos"
```

Vamos analisar o **valor total pago agrupado por UF**:
```
SELECT uf
    ,format('%,.2f',sum(quantidade * valor_unitario)) vl_total
FROM "ecommerce"."pedidos"
GROUP BY ROLLUP (uf)
ORDER BY sum(quantidade * valor_unitario) DESC
```

Quais foram os top 10 clientes que mais compraram?

```
WITH top_clientes as (
    SELECT id_cliente
        ,format('%,.2f',sum(quantidade * valor_unitario)) vl_total
    FROM "ecommerce"."pedidos"
    GROUP BY id_cliente
    ORDER BY sum(quantidade * valor_unitario) DESC
    LIMIT 10
) 
SELECT c.nome, c.cpf, t.*
FROM top_clientes t
INNER JOIN ecommerce.clientes c on c.id = t.id_cliente;

```