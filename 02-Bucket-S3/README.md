Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# 02 - Bucket S3

O objetivo desta sessão é criar o bucket S3 e estrutura de diretórios necessários à execução do laboratório.

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

