# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

## 06 - Glue ETL

O objetivo desta sessão é executar operações de extração, transformação e carga (ETL) utilizando o Glue Job

### Criando um job baseado em notebook
1. Na barra de pesquisa, busque por **Glue** a seguir clique em **AWS Glue**;
2. No painel lateral (esquerdo), abaixo de **ETL Jobs**, clique em **Notebooks**;
3. Na tela **AWS Glue Studio**, na sessão **Create job**, clique em **Notebook**;
4. No tela sobreposta **Notebook** que se abrir:
    - No combo **Engine** mantenha **Spark (Python)**;
    - No menu de seleção **Options** escolha **Upload Notebook**;
    - Clique no botão **Choose file**;
    - Escolha o arquivo `glue-job-pedidos.ipynb` e faça o upload;
    - No combo **IAM Role**, escolha a role disponível (normalmente o nome é **LabRole**);
    - Clique no botão **Create notebook**.
5. No topo superior esquerdo clique em **Untitled job**, apague o conteúdo e digite `pedidos parquet` e pressione a tecla Enter;

A partir desse ponto você deve seguir as instruções contidas no notebook.