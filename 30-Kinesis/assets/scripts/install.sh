# Criado por: Prof. Marcelo Barbosa
# Criado em: Janeiro/2024
# Github: https://github.com/infobarbosa
# Linkedin: https://www.linkedin.com/in/infobarbosa/


echo "01. Obtendo o ARN da role"
export LAB_ROLE=$(aws iam get-role --role-name LabRole | jq '.Role.Arn' -r)
echo "ARN da role: " $LAB_ROLE

echo "02. Instalando a Função Lambda na AWS"
aws lambda create-function \
    --function-name gerador-pedidos \
    --zip-file fileb://function.zip \
    --handler lambda_function.lambda_handler \
    --runtime python3.12 \
    --role $LAB_ROLE \
    --timeout 900

echo "Lambda instalada com sucesso!"