npm run build

cd ./build/landing-page
zip -r landing-page.zip .
cd ../add-dog
zip -r add-dog.zip .
cd ../validate-dog
zip -r validate-dog.zip .
cd ../get-dogs
zip -r get-dogs.zip .
cd ../../

if [ -f bucket-name.txt ]; then
    ID=$RANDOM
    ARTIFACT_BUCKET=$(cat bucket-name.txt)
    BUFFER=$(aws s3api put-object --bucket $ARTIFACT_BUCKET --key landing-page-$ID.zip --body ./build/landing-page/landing-page.zip)
    BUFFER=$(aws s3api put-object --bucket $ARTIFACT_BUCKET --key add-dog-$ID.zip --body ./build/add-dog/add-dog.zip)
    BUFFER=$(aws s3api put-object --bucket $ARTIFACT_BUCKET --key validate-dog-$ID.zip --body ./build/validate-dog/validate-dog.zip)
    BUFFER=$(aws s3api put-object --bucket $ARTIFACT_BUCKET --key get-dogs-$ID.zip --body ./build/get-dogs/get-dogs.zip)

    ARTIFACT_BUCKET=$(cat bucket-name.txt)
    aws cloudformation deploy  --template-file template.yml --parameter-overrides S3BucketLambdasLocation=$ARTIFACT_BUCKET S3KeyLandingPage=landing-page.zip S3KeyAddDog=add-dog-$ID.zip S3KeyValidateDog=validate-dog-$ID.zip S3KeyGetDogs=get-dogs-$ID.zip --stack-name x-ray-aws-sample --capabilities CAPABILITY_IAM
fi