import fetch from "node-fetch";
const ResponseURL =
  "https://cloudformation-custom-resource-response-uswest1.s3-us-west-1.amazonaws.com/arn%3Aaws%3Acloudformation%3Aus-west-1%3A281813604214%3Astack/x-ray-sample/27003790-b8ae-11ee-a518-06046569daab%7CS3CustomResource%7Cb87be6a2-fa4d-4383-afe7-7ff7dda85a27?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240121T224140Z&X-Amz-SignedHeaders=host&X-Amz-Expires=7200&X-Amz-Credential=AKIA3MSIBDUEHMXPJH3Z%2F20240121%2Fus-west-1%2Fs3%2Faws4_request&X-Amz-Signature=f07bdd5a0f3b0e406901fd0607b379ed6be3416dbcd97742e3d45ab2336c39b1";

const main = async () => {
  const response = await fetch(ResponseURL, {
    Status: "FAILED",
    Reason:
      "See the details in CloudWatch Log Stream: 2024/01/21/[$LATEST]04209f8243f44d489e6707e62c30e384",
    PhysicalResourceId: "2024/01/21/[$LATEST]04209f8243f44d489e6707e62c30e384",
    StackId:
      "arn:aws:cloudformation:us-west-1:281813604214:stack/x-ray-sample/27003790-b8ae-11ee-a518-06046569daab",
    RequestId: "b87be6a2-fa4d-4383-afe7-7ff7dda85a27",
    LogicalResourceId: "S3CustomResource",
    NoEcho: false,
  });
  console.log(response);
};

main();
