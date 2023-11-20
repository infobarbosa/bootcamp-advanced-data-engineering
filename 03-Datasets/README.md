Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 02 - Bases de dados

O objetivo desta sessão é obter os datasets (bases de dados) necessários à execução do laboratório.

### Atenção!
> O professor disponibilizará um ou mais links (mais especificamente URLs pré-assinadas) para download dos datasets.

![img/001_dataset_presigned_url_example.png](img/001_dataset_presigned_url_example.png)

Há dois métodos descritos nessa sessão: via console AWS S3 (mais simples) e via terminal AWS Cloud9.

## Método 1 - Console AWS S3
Neste método você deve fazer o download das bases de dados via navegador para a sua máquina e então fazer o upload das bases para o diretório especificado pelo professor.

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


