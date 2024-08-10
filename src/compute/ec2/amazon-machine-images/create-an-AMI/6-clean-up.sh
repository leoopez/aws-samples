# Clean up the temporary files and delete the cloudformation stacks

echo "Deleting the CloudFormation first stack"
STACK1=$(aws cloudformation delete-stack --stack-name my-ec2-instance-stack)

echo "Deleting the CloudFormation second stack"
STACK2=$(aws cloudformation delete-stack --stack-name my-ec2-instance-from-custom-AMI-stack)

echo "Getting the Snapshot ID to delete"

IMAGEID=$(cat image-id.txt)
SNAPSHOTID=$(aws ec2 describe-images --image-ids $IMAGEID --query 'Images[0].BlockDeviceMappings[0].Ebs.SnapshotId' --output text)

echo "Deregister Custom Image"
DEREGISTER_IMAGE=$(aws ec2 deregister-image --image-id $IMAGEID)


echo "Delete Snapshot Image"
DELETE_SNAPSHOT=$(aws ec2 delete-snapshot --snapshot-id $SNAPSHOTID)

echo "Deleting the temporary files"

rm image-id.txt
rm custom-key-pair.pem
rm new-key-pair.pem

echo "Clean up completed successfully"

# If known host was added to the known_hosts file, remove it