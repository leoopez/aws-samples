# Get connection to the EC2 instance to validate the user data

echo "Getting connection to the EC2 instance and get the CustomImageKeyPair"
CustomImageKeyPair=$(aws ec2 describe-key-pairs \
    --filters Name=key-name,Values=custom-new-key-pair \
    --region us-west-2 \
    --query 'KeyPairs[0].KeyPairId' \
    --output text)

echo "Get private key from SSM and saving to a file"
aws ssm get-parameter \
    --name /ec2/keypair/$CustomImageKeyPair \
    --with-decryption \
    --region us-west-2 \
    --query Parameter.Value \
    --output text > custom-key-pair.pem

echo "Changing the permissions of the private key file"
chmod 400 "custom-key-pair.pem"

echo "Getting the public DNS of the EC2 instance from the Output of the CloudFormation stack"
PublicDnsName=$(aws cloudformation describe-stacks \
    --stack-name my-ec2-instance-from-custom-AMI-stack  \
    --region us-west-2 \
    --query 'Stacks[0].Outputs[?OutputKey == `CustomImageInstancePublicDnsName`].OutputValue' \
    --output text)

echo "Connecting to the EC2 instance";
ssh -i "custom-key-pair.pem" ec2-user@$PublicDnsName

## Inside the EC2 instance shell, type the following command to check the file exits:
## docker

## If the command exists, type the following command to exit from the EC2 instance shell:
## exit