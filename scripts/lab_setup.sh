echo "### Atualizando o sistema ###"
sudo apt update -y

echo "### Instalando o pacote boto3  ###"
pip install boto3

echo "### Instalando o jq, a lightweight and flexible command-line JSON processor  ###"
sudo apt install -y jq

echo "### Redimensionando o disco ###"
echo "### O tamanho desejado em GiB ###"
SIZE=150

echo "### O ID da instância EC2 do ambiente Cloud9 ###"
INSTANCEID=$(curl http://169.254.169.254/latest/meta-data//instance-id)

echo "### O ID do disco EBS associado a essa instância ###"
VOLUMEID=$(aws ec2 describe-instances --instance-id $INSTANCEID | jq -r .Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId)

echo "### Redimensionamento do volume EBS ###"
aws ec2 modify-volume --volume-id $VOLUMEID --size $SIZE

echo "### Aguardando a finalização do redimensionamento. ###"
while [ "$(aws ec2 describe-volumes-modifications --volume-id $VOLUMEID --filters Name=modification-state,Values="optimizing","completed" | jq '.VolumesModifications | length')" != "1" ]; do
	echo "waiting volume..."
	sleep 1
done

echo "### Reescrevendo a tabela de partição para uso full do espaço solicitado. ###"
sudo growpart /dev/nvme0n1 1

echo "### Expandindo o tamanho do sistema de arquivos. ###"
sudo resize2fs /dev/nvme0n1p1
