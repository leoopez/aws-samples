#Script to generate a AMI from an EC2 instance.
echo "Creating a AMI from the EC2 instance"

IMAMGESOURCEID=$(cat image-id.txt)
aws ec2 copy-image \
    --region us-east-1 \
    --name ami-copy-iamge \
    --source-region us-west-2 \
    --source-image-id $IMAMGESOURCEID \
    --description "This is my copied image." \
    --query 'ImageId' \
    --output text > image-copy-id.txt
    
echo "AMI copy successfully"