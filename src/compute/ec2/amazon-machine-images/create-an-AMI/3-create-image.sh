echo "Get the instance ID of the EC2 instance"

INSTANCE_ID=$(aws cloudformation describe-stacks --stack-name my-ec2-instance-stack --query 'Stacks[0].Outputs[?OutputKey == `InstanceId`].OutputValue' --output text)

echo "Creating a AMI from the EC2 instance"

aws ec2 create-image --instance-id $INSTANCE_ID --name "My Hello World Image"  --query 'ImageId' --output text
