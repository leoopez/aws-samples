echo "Getting connection to the EC2 instance"
KeyPairId=$(aws ec2 describe-key-pairs --filters Name=key-name,Values=new-key-pair --query 'KeyPairs[0].KeyPairId' --output text)

echo "Saviing the private key to a file"
aws ssm get-parameter --name /ec2/keypair/$KeyPairId   --with-decryption --query Parameter.Value --output text > new-key-pair.pem

echo "Changing the permissions of the private key file"
chmod 400 "new-key-pair.pem"

echo "Getting the public DNS of the EC2 instance"
PublicDnsName=$(aws cloudformation describe-stacks --stack-name my-ec2-instance-stack --query 'Stacks[0].Outputs[?OutputKey == `PublicDnsName`].OutputValue' --output text)

echo "Connecting to the EC2 instance";
ssh -i "new-key-pair.pem" ec2-user@$PublicDnsName

## Inside the EC2 instance shell, type the following command to check the file exits:
## ls -l /tmp/hello-world.txt

## If exists, type the following command to exit from the EC2 instance shell:
## exit