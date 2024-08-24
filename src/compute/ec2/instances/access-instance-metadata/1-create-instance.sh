# Create an ec2 intance with a role that allows access to instance metadata

# Step 1: Get ImageId from input
echo "Enter the ImageId to use for the instance:"
echo "If you don't have an ImageId, you can get one by running the script src/compute/ec2/amazon-machine-images/get-available-AMIS/1-get-available-AMIS.sh"
echo ""
printf "ImageId: "
read ImageId

# Step 2: Create a CloudFormation stack
aws cloudformation create-stack --stack-name access-instance-metadata \
  --template-body file://$(pwd)/template.yaml \
  --parameters ParameterKey=ImageId,ParameterValue=$ImageId \


echo Creating instance that allows access to instance metadata

aws cloudformation wait stack-create-complete --stack-name access-instance-metadata

# Step 3: Get connection to the EC2 instance to validate the user data
echo "Getting connection to the EC2 instance and get the CustomImageKeyPair"
KeyPairID=$(aws ec2 describe-key-pairs \
    --filters Name=key-name,Values=new-key-pair \
    --region us-west-2 \
    --query 'KeyPairs[0].KeyPairId' \
    --output text)

echo "Get private key from SSM and saving to a file"
aws ssm get-parameter \
    --name /ec2/keypair/$KeyPairID \
    --with-decryption \
    --region us-west-2 \
    --query Parameter.Value \
    --output text > custom-key-pair.pem

echo "Changing the permissions of the private key file"
chmod 400 "custom-key-pair.pem"

echo "Getting the public DNS of the EC2 instance from the Output of the CloudFormation stack"
PublicDnsName=$(aws cloudformation describe-stacks \
    --stack-name access-instance-metadata  \
    --region us-west-2 \
    --query 'Stacks[0].Outputs[?OutputKey == `PublicIP`].OutputValue' \
    --output text)

echo "Connecting to the EC2 instance";
ssh -i "custom-key-pair.pem" ec2-user@$PublicDnsName

## Inside the EC2 instance shell, type the following command to play with the instance metadata:

## #!/bin/bash

# # Get the instance ID
# instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
# echo "Instance ID: $instance_id"

# # Get the AMI ID
# ami_id=$(curl -s http://169.254.169.254/latest/meta-data/ami-id)
# echo "AMI ID: $ami_id"

# # Get the instance type
# instance_type=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
# echo "Instance Type: $instance_type"

# # Get the public hostname
# public_hostname=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
# echo "Public Hostname: $public_hostname"

# # Get the public IP address
# public_ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
# echo "Public IP: $public_ip"

# # Get the security groups
# security_groups=$(curl -s http://169.254.169.254/latest/meta-data/security-groups)
# echo "Security Groups: $security_groups"