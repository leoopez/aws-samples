#!/bin/bash
set -eo pipefail

echo Create S3 bucket

ID=$RANDOM-$RANDOM
SOURCE_BUCKET_NAME=x-ray-sample-$ID
# LANDING_PAGE_BUCKET_NAME=x-ray-aws-sample-landig-page-$ID

BUFFER=$(aws s3api create-bucket --bucket $SOURCE_BUCKET_NAME --region us-west-1  --create-bucket-configuration LocationConstraint=us-west-1 --query 'Location' --output text)
# BUFFER=$(aws s3api create-bucket --bucket $LANDING_PAGE_BUCKET_NAME --region us-west-1  --create-bucket-configuration LocationConstraint=us-west-1 --query 'Location' --output text)

echo $SOURCE_BUCKET_NAME > source-bucket-name.txt

echo Create Bundle for Lambdas \& Landing Page
npm install
npm run build

mkdir -p ./build/custom-function && cp  ./functions/custom-function/index.js ./build/custom-function/index.js
cd ./build/add-dog
zip -r add-dog.zip .
cd ../validate-dog
zip -r validate-dog.zip .
cd ../get-dogs
zip -r get-dogs.zip .
cd ../custom-function
zip -r custom-function.zip .

cd ../../dist
zip -r dist.zip .
cd ..


BUFFER=$(aws s3api put-object --bucket $SOURCE_BUCKET_NAME --key custom-function.zip --body ./build/custom-function/custom-function.zip)
BUFFER=$(aws s3api put-object --bucket $SOURCE_BUCKET_NAME --key add-dog.zip --body ./build/add-dog/add-dog.zip)
BUFFER=$(aws s3api put-object --bucket $SOURCE_BUCKET_NAME --key validate-dog.zip --body ./build/validate-dog/validate-dog.zip)
BUFFER=$(aws s3api put-object --bucket $SOURCE_BUCKET_NAME --key get-dogs.zip --body ./build/get-dogs/get-dogs.zip)
BUFFER=$(aws s3api put-object --bucket $SOURCE_BUCKET_NAME --key dist.zip --body ./dist/dist.zip)


aws cloudformation deploy  --template-file template.yml --parameter-overrides \
    S3BucketLambdasLocation=$SOURCE_BUCKET_NAME \
    S3KeyLandingPage=dist.zip \
    S3KeyAddDog=add-dog.zip \
    S3KeyValidateDog=validate-dog.zip \
    S3KeyGetDogs=get-dogs.zip \
    S3KeyCustomFunction=custom-function.zip \
    --stack-name x-ray-sample --capabilities CAPABILITY_IAM
