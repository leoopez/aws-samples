#Bash Script to create an EC2 instance using a standard AMI and customize it using user data.
STACKID=$(aws cloudformation create-stack \
    --stack-name my-ec2-instance-stack \
    --template-body file://./create-cutomize-instance.yaml)

echo "Waiting for the stack to be created"

aws cloudformation wait stack-create-complete --stack-name my-ec2-instance-stack

echo "Stack created successfully"

echo "creating an image from the EC2 instance"

INSTANCE_ID=$(aws cloudformation describe-stacks \
    --stack-name my-ec2-instance-stack \
    --query 'Stacks[0].Outputs[?OutputKey == `InstanceId`].OutputValue' \
    --output text)

aws ec2 create-image \
    --instance-id $INSTANCE_ID \
    --name "My Hello World Image"  \
    --query 'ImageId' \
    --output text > image-id.txt

echo "AMI created successfully"