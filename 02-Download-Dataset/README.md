Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 02 - Bases de dados

O objetivo desta sessão é obter os datasets (bases de dados) necessários à execução do laboratório.

### Atenção!
O professor disponibilizará um ou mais links (mais especificamente URLs pré-assinadas) para download dos datasets.

![img/001_dataset_presigned_url_example.png](img/001_dataset_presigned_url_example.png)

## Bucket S3
Vamos criar o bucket e estrutura de para onde vamos fazer o upload dos arquivos.

1. Digite `s3` na barra de buscas do console AWS 

![img/007_bucket_s3_barra_de_busca.png](img/007_bucket_s3_barra_de_busca.png)

2. Clique em `S3` 

![img/008_bucket_s3_menu_s3.png](img/008_bucket_s3_menu_s3.png)

Você será direcionado para a página inicial do S3:

![img/009_bucket_s3_pagina_inicial_s3.png](img/009_bucket_s3_pagina_inicial_s3.png)

3. Clique em **Criar bucket**<br>
Preencha as informações desta tela conforme a seguir:

4. **Nome do bucket**: `lab-data-eng-[ANOMÊS]-[NUMERO ALEATORIO]`

- Substitua [ANOMÊS] pelo ano e mês correntes no formato AAAAMM. 
- Substitua [NUMERO ALEATÓRIO] por um número aleatório qualquer. 

Exemplo: 
```
lab-data-eng-202311-12345
```
O objetivo do número aleatório é não haver colisão de nomes entre os diversos laboratórios.

![img/010_bucket_s3_nome_bucket.png](img/010_bucket_s3_nome_bucket.png)

5. Região da AWS<br>
Mantenha inalterado

![img/011_bucket_s3_regiao_aws.png](img/011_bucket_s3_regiao_aws.png)

6. **Propriedade de objeto**<br>
Mantenha inalterado

![img/012_bucket_s3_propriedade_de_objeto.png](img/012_bucket_s3_propriedade_de_objeto.png)

7. **Configurações de bloqueio do acesso público deste bucket**<br>
Mantenha inalterado

![img/013_bucket_s3_bloquear_acesso_publico.png](img/013_bucket_s3_bloquear_acesso_publico.png)

8. **Versionamento de bucket**<br>
Mantenha inalterado

![img/014_bucket_s3_versionamento_de_bucket.png](img/014_bucket_s3_versionamento_de_bucket.png)

9. **Tags**<br>
Mantenha inalterado

![img/015_bucket_s3_tags.png](img/015_bucket_s3_tags.png)

10. **Criptografia padrão**<br>
Mantenha inalterado

![img/016_bucket_s3_criptografia_padrao.png](img/016_bucket_s3_criptografia_padrao.png)

11. Clique em **Criar bucket** ao final da página

![img/017_bucket_s3_botao_criar_bucket.png](img/017_bucket_s3_botao_criar_bucket.png)

12. Você será direcionado ao painel onde é exibido o conteúdo do bucket criado <br>

![img/018_bucket_s3_bucket_criado.png](img/018_bucket_s3_bucket_criado.png)

13. Clique em **Criar pasta**<br>

![img/019_bucket_s3_botao_criar_pasta.png](img/019_bucket_s3_botao_criar_pasta.png)

14. Informe `raw` como nome da pasta e deixe os demais campos inalterados. <br>

![img/020_bucket_s3_pagina_criar_pasta.png](img/020_bucket_s3_pagina_criar_pasta.png)

## Baixando bases para o Cloud9

1. Crie um diretório `data` embaixo do diretório raiz `/home/ubuntu`
```
mkdir -p /home/ubuntu/data
```

2. Navegue para o diretório criado

```
cd /home/ubuntu/data
```
### 1o dataset 
3. Crie uma variável de ambiente `PRESIGNED_URL_1` com a primeira URL pré-assinada disponibilizada pelo professor.

![img/002_dataset_presigned_url_env_variable_1.png](img/002_dataset_presigned_url_env_variable_1.png)
Atenção! Perceba que a URL pré-assinada precisa estar entre aspas duplas.

4. Execute o comando `curl` para download do primeiro dataset:

```
curl -o "201301_BolsaFamilia_Pagamentos_utf-8.zip" ${PRESIGNED_URL_1}
```

![img/003_dataset_download_curl_command_1.png](img/003_dataset_download_curl_command_1.png)

Atenção! O nome do arquivo na sintaxe do `curl` precisa corresponder ao arquivo da URL pré-assinada e também estar entre aspas duplas.

### 2o dataset
Execute o mesmo procedimento para download do segundo dataset:

5. Crie uma variável de ambiente `PRESIGNED_URL_2` com a segunda URL pré-assinada disponibilizada pelo professor. 

![img/004_dataset_presigned_url_env_variable_2.png](img/004_dataset_presigned_url_env_variable_2.png)
```
curl -o "202303_NovoBolsaFamilia_utf-8.zip" ${PRESIGNED_URL_2}
```
![img/005_dataset_download_curl_command_2.png](img/005_dataset_download_curl_command_2.png)

6. Após os dois downloads, seu diretório estará assim: 

![img/006_dataset_listando_arquivos_baixados.png](img/006_dataset_listando_arquivos_baixados.png)


