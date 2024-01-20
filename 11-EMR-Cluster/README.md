# Bootcamp Advanced Data Engineering
Author: Prof. Barbosa<br>
Contact: infobarbosa@gmail.com<br>
Github: [infobarbosa](https://github.com/infobarbosa)

# EMR
O objetivo deste exercício é ativar um cluster EMR e executar algumas operações em lote (batch) sobre o mesmo.

> ## Atenção!
> ### Custo
> Parte dos recursos alocados para o cluster EMR continuam sendo cobrados mesmo que desligados.<br>
> Portanto, recomenda-se **eliminar** o cluster e realocá-lo novamente entre as suas sessões de estudo.
>
> ### Chaves criptográficas
> Este exercício faz uso de uma chave criptográfica (key pair) para acesso SSH. <br>
> Caso esteja utilizando o **AWS Academy**, a key pair `vockey` escolhida é disponibilizada na página do **Vocaerum**.<br>
> Clique em **AWS Details** e na sequência em **Download PEM**.<br> 
> Arraste então o arquivo `labsuser.pem` da sua máquina para a pasta do projeto no **AWS Cloud9**.<br>
> Execute o comando:
```
chmod 600 labsuser.pem 
```
> Liste o arquivo para checar as permissões:
```
ls -la
```

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ ls -la labsuser.pem
-rw------- 1 ubuntu ubuntu 1678 Jan 20 13:09 labsuser.pem 
```

## Criação do cluster

### Via Console AWS 
1. Na barra de busca digite **EMR**, clique no link disponibilizado;
2. Na tela principal do EMR, clique em **Create cluster**;
3. No campo **Name** digite `dataeng-lab`;
4. Em **Amazon EMR release**, selecione **emr-6.15.0**;
5. Em **Application bundle**, selecione **Spark Interactive**;
6. Abaixo é exibida uma lista de componentes. Mantenha inalterado;
7. Na sessão **Cluster configuration**, selecione **Uniform instance groups**;
8. Na sessão **Instance groups section** selecione **m4.large** para **Primary**, **Core** e **Task 1 of 1**;
9. Role a tela até a sessão **Networking**;
10. Em **Virtual private (VPC)**, verifique a VPC pré-selecionada, mas mantenha inalterado;
11. Em **Subnet**, verifique a subnet pré-selecionada, mas mantenha inalterada;
12. Role a tela até a sessão **Cluster termination**;
13. Em **Cluster termination**, selecione **Manually terminate cluster**;
14. Role a tela até a sessão **Security configuration and EC2 key pair**;
15. Em **Security configuration**, deixe em branco;
16. Em **Amazon EC2 key pair for SSH to the cluster**, escolha **vockey**;
17. Role a tela até a sessão **Identity and Access Management (IAM) roles**;
18. Em **Amazon EMR service role**, selecione **Choose an existing service role**;
19. Em **Service role**, selecione **EMR_DefaultRole**;
20. Em **EC2 instance profile for Amazon EMR**, escolha **Choose an existing instance profile;
21. Em **Instance profile**, selecione ** **EMR_EC2_DefaultRole**;
21. Clique em **Create cluster**;

A criação e ativação do cluster leva em torno de 10 minutos.

---

## Acesso ao cluster

Esta sessão tem por objetivo conectar no cluster que acabamos de criar e então executar alguns comandos utilizando Spark shell.

> ## Atenção!
> Será necessário adicionar uma regra ao security group para permitir o acesso via porta ssh (porta 22).<br>
> 1. Na barra de busca superior digite `security groups` e então clique em **Security groups**.
> 2. Na tela **Security groups** clique no **Security group ID** referente à linha com **Security group name** igual a `ElasticMapReduce-master`;
> 3. Na aba **Inbound rules** clique em **Edit inbound rules**;
> 4. Clique em **Add rule**;
> 5. No combo **Type** digite e selecione **SSH**;
> 6. No campo editável **Source** clique e selecione o security group cujo nome se inicia com **aws-cloud9-lab-...**;
> 7. Clique em **Save rules**.


1. Abra o terminal (shell) do **Cloud9**;

2. Obtenha o ID do cluster EMR via terminal **Cloud9**
```
export ID=$(aws emr list-clusters | jq '.Clusters[0].Id' | tr -d '"')
```

```
echo ${ID}
```

3. Use o ID para obter o DNS público do cluster
```
export MASTER_HOST=$(aws emr describe-cluster --cluster-id $ID | jq '.Cluster.MasterPublicDnsName' | tr -d '"')
```

```
echo $MASTER_HOST
```

4. Conecte-se ao cluster via SSH
```
ssh -i ./labsuser.pem hadoop@$MASTER_HOST
```
Caso apresentado um prompt de confirmação, responda `yes` e ditite **ENTER**.

Output esperado:
```
voclabs:~/environment/bootcamp-advanced-data-engineering (main) $ ssh -i ./labsuser.pem hadoop@$MASTER_HOST
Last login: Sat Jan 20 13:55:03 2024
   ,     #_
   ~\_  ####_        Amazon Linux 2
  ~~  \_#####\
  ~~     \###|       AL2 End of Life is 2025-06-30.
  ~~       \#/ ___
   ~~       V~' '->
    ~~~         /    A newer version of Amazon Linux is available!
      ~~._.   _/
         _/ _/       Amazon Linux 2023, GA and supported until 2028-03-15.
       _/m/'           https://aws.amazon.com/linux/amazon-linux-2023/

                                                                    
EEEEEEEEEEEEEEEEEEEE MMMMMMMM           MMMMMMMM RRRRRRRRRRRRRRR    
E::::::::::::::::::E M:::::::M         M:::::::M R::::::::::::::R   
EE:::::EEEEEEEEE:::E M::::::::M       M::::::::M R:::::RRRRRR:::::R 
  E::::E       EEEEE M:::::::::M     M:::::::::M RR::::R      R::::R
  E::::E             M::::::M:::M   M:::M::::::M   R:::R      R::::R
  E:::::EEEEEEEEEE   M:::::M M:::M M:::M M:::::M   R:::RRRRRR:::::R 
  E::::::::::::::E   M:::::M  M:::M:::M  M:::::M   R:::::::::::RR   
  E:::::EEEEEEEEEE   M:::::M   M:::::M   M:::::M   R:::RRRRRR::::R  
  E::::E             M:::::M    M:::M    M:::::M   R:::R      R::::R
  E::::E       EEEEE M:::::M     MMM     M:::::M   R:::R      R::::R
EE:::::EEEEEEEE::::E M:::::M             M:::::M   R:::R      R::::R
E::::::::::::::::::E M:::::M             M:::::M RR::::R      R::::R
EEEEEEEEEEEEEEEEEEEE MMMMMMM             MMMMMMM RRRRRRR      RRRRRR
                                                                    
[hadoop@ip-172-31-81-171 ~]$ 

```

5. Vamos criar uma variável de ambiente `bucket`
```
export bucket=$(aws s3api list-buckets --query "Buckets[].Name" | grep 'lab-data-eng' | tr -d ' ' | tr -d '"' | tr -d ',')

echo $bucket

```

6. Abra o spark-shell
```
spark-shell
```

> A ativação do spark-shell leva de 1 a 2 minutos.

Output esperado:
```
[hadoop@ip-172-31-81-171 ~]$ spark-shell
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
24/01/20 14:09:34 WARN Client: Neither spark.yarn.jars nor spark.yarn.archive is set, falling back to uploading libraries under SPARK_HOME.
24/01/20 14:10:00 WARN YarnSchedulerBackend$YarnSchedulerEndpoint: Attempted to request executors before the AM has registered!
Spark context Web UI available at http://ip-172-31-81-171.ec2.internal:4040
Spark context available as 'sc' (master = yarn, app id = application_1705757433450_0001).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.4.1-amzn-2
      /_/
         
Using Scala version 2.12.15 (OpenJDK 64-Bit Server VM, Java 1.8.0_402)
Type in expressions to have them evaluated.
Type :help for more information.

scala> 
```

7. Crie um Dataframe a partir do dataset `clientes.csv.gz`
```
val bucket = System.getenv("bucket")
```

```
val clientes_loc = "s3://"+bucket+"/raw/ecommerce/clientes/clientes.csv.gz"
```

```
val df = spark.read.option("header","true").option("inferSchema","true").option("delimiter", ";").option("compression", "gzip").csv(clientes_loc)
```

Output esperado:
```
scala> val df = spark.read.option("header","true").option("inferSchema","true").option("delimiter", ";").option("compression", "gzip").csv(clientes_loc)
df: org.apache.spark.sql.DataFrame = [id: int, nome: string ... 3 more fields]  
```

8. Inspecione os dados do dataframe
```
df.printSchema()
```

Output esperado:
```
scala> df.printSchema()
root
 |-- id: integer (nullable = true)
 |-- nome: string (nullable = true)
 |-- data_nasc: date (nullable = true)
 |-- cpf: string (nullable = true)
 |-- email: string (nullable = true)
```

```
df.show(5)
```
Output esperado:
```
scala> df.show(5)
+---+--------------------+----------+--------------+--------------------+       
| id|                nome| data_nasc|           cpf|               email|
+---+--------------------+----------+--------------+--------------------+
|  1|    Isabelly Barbosa|1963-08-15|137.064.289-03|isabelly.barbosa@...|
|  2|      Larissa Fogaça|1933-09-29|703.685.294-10|larissa.fogaca@ex...|
|  3|João Gabriel Silv...|1958-05-27|520.179.643-52|joao.gabriel.silv...|
|  4|Pedro Lucas Nasci...|1950-08-23|274.351.896-00|pedro.lucas.nasci...|
|  5|      Felipe Azevedo|1986-12-31|759.061.842-01|felipe.azevedo@ex...|
+---+--------------------+----------+--------------+--------------------+
only showing top 5 rows
```

```
df.describe()
```
Output esperado:
```
scala> df.describe()
res5: org.apache.spark.sql.DataFrame = [summary: string, id: string ... 3 more fields]
```

Analise atentamente os resultados. 

9. Para sair do spark-shell digite:
```
sys.exit
```

### Parabéns!
Se você chegou até aqui então criou e ativou seu cluster EMR com sucesso e fez testes utilizando linguagem Scala. 