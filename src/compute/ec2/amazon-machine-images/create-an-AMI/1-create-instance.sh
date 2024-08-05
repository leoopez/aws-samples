echo "Check if Stack already exists"

aws cloudformation describe-stacks --stack-name my-ec2-instance-stack
if [ $? -eq 0 ]; then
    echo "Stack, already exists, updating the stack..."
    aws cloudformation update-stack --stack-name my-ec2-instance-stack --template-body file://./create-cutomize-instance.yaml
else
    echo "Creating the stack..."
    aws cloudformation create-stack --stack-name my-ec2-instance-stack --template-body file://./create-cutomize-instance.yaml
fi

