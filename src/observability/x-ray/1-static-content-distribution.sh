#!/bin/bash
set -eo pipefail

echo Create S3 bucket

ID=$RANDOM-$RANDOM
SOURCE_BUCKET_NAME=static-content-distribution-$ID

BUFFER=$(aws s3api create-bucket --bucket $SOURCE_BUCKET_NAME --region us-west-1  --create-bucket-configuration LocationConstraint=us-west-1 --query 'Location' --output text)

echo $SOURCE_BUCKET_NAME > source-bucket-name.txt

cd mad-metal

npx astro build

cd dist 

aws s3 cp . s3://$SOURCE_BUCKET_NAME/ --recursive
