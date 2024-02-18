# Criado por: Prof. Marcelo Barbosa
# Criado em: Janeiro/2024
# Github: https://github.com/infobarbosa
# Linkedin: https://www.linkedin.com/in/infobarbosa/

echo "Invocando a função Lambda"

aws lambda invoke \
    --function-name gerador-pedidos \
    --invocation-type Event \
    --cli-binary-format raw-in-base64-out \
    out.json

echo "Lambda instalada com sucesso!"