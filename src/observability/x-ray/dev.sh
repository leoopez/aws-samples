
SOURCE_BUCKET_NAME=$(cat source-bucket-name.txt)
npm install
npm run build

cd ./build/add-dog
zip -r add-dog.zip .
cd ../validate-dog
zip -r validate-dog.zip .
cd ../get-dogs
zip -r get-dogs.zip .
cd ../custom-function
zip -r custom-function.zip .

cd ../../static
npx vite build
cd ./dist

zip -r dist.zip .

cd ../../

BUFFER=$(aws s3api put-object --bucket $SOURCE_BUCKET_NAME --key custom-function.zip --body ./build/custom-function/custom-function.zip)
BUFFER=$(aws s3api put-object --bucket $SOURCE_BUCKET_NAME --key add-dog.zip --body ./build/add-dog/add-dog.zip)
BUFFER=$(aws s3api put-object --bucket $SOURCE_BUCKET_NAME --key validate-dog.zip --body ./build/validate-dog/validate-dog.zip)
BUFFER=$(aws s3api put-object --bucket $SOURCE_BUCKET_NAME --key get-dogs.zip --body ./build/get-dogs/get-dogs.zip)
BUFFER=$(aws s3api put-object --bucket $SOURCE_BUCKET_NAME --key dist.zip --body ./static/dist/dist.zip)


aws cloudformation deploy  --template-file template.yml --parameter-overrides \
    S3BucketLambdasLocation=$SOURCE_BUCKET_NAME \
    S3KeyLandingPage=dist.zip \
    S3KeyAddDog=add-dog.zip \
    S3KeyValidateDog=validate-dog.zip \
    S3KeyGetDogs=get-dogs.zip \
    S3KeyCustomFunction=custom-function.zip \
    --stack-name x-ray-sample --capabilities CAPABILITY_IAM
