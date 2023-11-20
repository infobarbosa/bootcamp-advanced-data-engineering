Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 03 - Bases de dados

O objetivo desta sessão é obter os datasets (bases de dados) necessários à execução do laboratório.

### Atenção!
> O professor disponibilizará um ou mais links (mais especificamente URLs pré-assinadas) para download dos datasets.

![img/001_dataset_presigned_url_example.png](img/001_dataset_presigned_url_example.png)

Há dois métodos descritos nessa sessão: via console AWS S3 (mais simples) e via terminal AWS Cloud9.

## Método 1 - Console AWS S3
Neste método você deve fazer o download das bases de dados via navegador para a sua máquina e então fazer o upload das bases para o diretório especificado pelo professor.

1. Para cada link disponibilizado pelo professor, copie e cole na barra de endereços em uma nova aba do seu navegador. O download será iniciado automaticamente, aguarde o término.

2. Acesse o console AWS S3

3. Navegue para o bucket criado no passo 2 `02-Bucket-S3`

4. Navegue para a pasta `raw`

![img/007_dataset_pasta_raw.png](img/007_dataset_pasta_raw.png)

5. Clique no botão Upload

![img/008_dataset_tela_upload.png](img/008_dataset_tela_upload.png)

6. Escolha o arquivo a ser carregado
> A escolha do arquivo pode ser via botão `Add files` ou apenas arrastando o arquivo para a página atual.

![img/009_dataset_tela_upload_com_arquivo.png](img/009_dataset_tela_upload_com_arquivo.png)

> Você pode escolher mais arquivos para executar um único upload.

7. Clique em `Upload` ao final da página.

8. Aguarde o término do upload

![img/010_dataset_barra_de_upload.png](img/010_dataset_barra_de_upload.png)

9. Verifique o status de upload `Succeeded`
![img/011_dataset_upload_completo.png](img/011_dataset_upload_completo.png)

10. Clique no botão ![img/014_botao_close.png](img/014_botao_close.png) 

> O botão encontra-se no topo da tela à direita.

11. Repita a operação para os demais arquivos

![img/012_dataset_upload_demais_arquivos.png](img/012_dataset_upload_demais_arquivos.png)

12. Clique em `Upload` ao final da página

13. Ao final do upload, clique no botão `Close` para fechar a página de upload.

![img/013_dataset_upload_demais_arquivos_completo.png](img/013_dataset_upload_demais_arquivos_completo.png)

## Método 2 - Terminal Cloud9

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


