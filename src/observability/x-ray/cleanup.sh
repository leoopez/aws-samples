#!/bin/zsh
echo "Deleted function stack"
aws cloudformation delete-stack --stack-name x-ray-aws-sample

ARTIFACT_BUCKET=$(cat bucket-name.txt)

if [ -f bucket-name.txt ]; then
    aws s3api delete-objects --bucket $ARTIFACT_BUCKET --delete $(aws s3api list-object-versions --bucket $ARTIFACT_BUCKET --output=json --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')
fi
rm -f bucket-name.txt