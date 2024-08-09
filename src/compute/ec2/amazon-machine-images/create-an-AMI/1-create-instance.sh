#Bash Script to create an EC2 instance using a standard AMI and customize it using user data.
echo "Check if Stack already exists"
TEMPLATE=$(aws cloudformation create-stack --stack-name my-ec2-instance-stack --template-body file://./create-cutomize-instance.yaml)

echo "Stack created successfully"