
# Listar as imagens disponíveis
aws ec2 describe-images --output json --region us-east-1 \
--filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*" \
--query 'sort_by(Images, &CreationDate)[-1].{Name: Name, ImageId: ImageId, CreationDate: CreationDate, Owner:OwnerId}'

# Selecionar a última imagem disponível
export IMAGE_ID=$(aws ec2 describe-images --output json --region us-east-1 \
--filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*" \
--query 'sort_by(Images, &CreationDate)[-1].{ImageId: ImageId}' | jq -r '.ImageId')

# Criar o ambiente cloud9
aws cloud9 create-environment-ec2 \
    --name lab-data-eng \
    --description "Ambiente cloud9 para o bootcamp de advanced data engineering." \
    --instance-type t2.micro \
    --automatic-stop-time-minutes 60 \
    --connection-type CONNECT_SSH \
    --image-id $IMAGE_ID


