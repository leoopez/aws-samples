## Create an instance from a custom image
#Bash Script to create an EC2 instance using a standard AMI and customize it using user data.

echo "Creating the stack..."
ImageId=$(cat image-id.txt)
echo "ImageId $ImageId"
TEMPLATE=$(aws cloudformation create-stack --stack-nam my-ec2-instance-from-custom-AMI-stack --template-body file://./create-instance-from-customize-image.yaml --parameters ParameterKey=ImageId,ParameterValue=$ImageId)

echo "Stack created successfully"