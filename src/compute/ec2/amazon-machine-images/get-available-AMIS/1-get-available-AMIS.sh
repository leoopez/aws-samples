# Get available AMIs from the AWS specified region

echo Get a available AMI from 


# Step 1: Select an AWS region
aws_regions=(
  "us-east-1"
  "us-east-2"
  "us-west-1"
  "us-west-2"
  "eu-west-1"
  "eu-west-2"
  "eu-west-3"
  "eu-north-1"
)

echo ""
echo "Available regions:"
for region in "${aws_regions[@]}"; do
    echo "  $region"
done
echo ""


printf "Select the region to get the available AMIs from (us-west-1): "
read seclected_region

if [ -z $seclected_region ]
then
    seclected_region="us-west-1"
elif [[ ! " ${aws_regions[@]} " =~ " ${seclected_region} " ]]
then
    echo "Invalid region selected."
    exit 1
fi

echo Getting the available AMIs from the region $seclected_region:

IMAGE_ID=$(aws ec2 describe-images \
    --owners amazon \
    --region $seclected_region \
    --filters "Name=description,Values='Canonical, Ubuntu, 24.04, amd64 noble image'" \
        "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240801" \
    --query 'Images[0].ImageId' \
    --output text)

echo "The AMI ID is: $IMAGE_ID"
