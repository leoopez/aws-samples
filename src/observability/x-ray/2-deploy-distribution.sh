SOURCE_BUCKET_NAME=$(cat source-bucket-name.txt)

aws cloudformation deploy  --template-file static-content-template.yml --parameter-overrides \
    S3BucketName=$SOURCE_BUCKET_NAME \
    --stack-name static-content-template --capabilities CAPABILITY_IAM
