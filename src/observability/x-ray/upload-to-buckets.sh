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
    ARTIFACT_BUCKET=$(cat bucket-name.txt)
    aws s3api put-object --bucket $ARTIFACT_BUCKET --key landing-page.zip --body ./build/landing-page/landing-page.zip
    aws s3api put-object --bucket $ARTIFACT_BUCKET --key add-dog.zip --body ./build/add-dog/add-dog.zip
    aws s3api put-object --bucket $ARTIFACT_BUCKET --key validate-dog.zip --body ./build/validate-dog/validate-dog.zip
    aws s3api put-object --bucket $ARTIFACT_BUCKET --key get-dogs.zip --body ./build/get-dogs/get-dogs.zip
fi