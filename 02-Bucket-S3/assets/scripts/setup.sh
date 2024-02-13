# Bootcamp Advanced Data Engineering
# Author: Prof. Barbosa<br>
# Contact: infobarbosa@gmail.com<br>
# Github: [infobarbosa](https://github.com/infobarbosa)

echo "Criando o bucket no S3 e subdiretórios"

# Obtenção do ID da conta AWS:
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query Account --output text`

# Obtenção do nome do usuário:
readarray -d '=' -t strarr <<< `aws sts get-caller-identity --output json | jq '.Arn | split("/")[-1]' -r`

export AWS_USER_NAME="${strarr[0]}"

#Criação da variável de ambiente `BUCKET_NAME`
export BUCKET_NAME=lab-data-eng-$(date '+%Y%m%d')-${AWS_ACCOUNT_ID}-${AWS_USER_NAME}

echo ${BUCKET_NAME}

# Criando o bucket
aws s3api create-bucket --bucket ${BUCKET_NAME}

aws s3 ls

aws s3api put-object --bucket ${BUCKET_NAME} --key raw/ecommerce/
aws s3api put-object --bucket ${BUCKET_NAME} --key stage/
aws s3api put-object --bucket ${BUCKET_NAME} --key analytics/
aws s3api put-object --bucket ${BUCKET_NAME} --key scripts/
aws s3api put-object --bucket ${BUCKET_NAME} --key results/
aws s3api put-object --bucket ${BUCKET_NAME} --key output/

aws s3 ls ${BUCKET_NAME}


