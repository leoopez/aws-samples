# Clean up the temporary files and delete the cloudformation stacks

echo "Deleting the CloudFormation first stack"
STACK1=$(aws cloudformation delete-stack --stack-name my-ec2-instance-stack)

echo "Deleting the CloudFormation second stack"
STACK2=$(aws cloudformation delete-stack --stack-name my-ec2-instance-from-custom-AMI-stack)

echo "Deregister Custom Image"
#TOFIX: This command is not working

echo "Deleting the temporary files"

rm image-id.txt
rm custom-key-pair.pem
rm new-key-pair.pem

echo "Clean up completed successfully"