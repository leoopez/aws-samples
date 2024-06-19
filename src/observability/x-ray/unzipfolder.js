const { promises: fs } = require("fs");
const decompress = require("decompress");
const { S3Client, GetObjectCommand } = require("@aws-sdk/client-s3");
const s3Client = new S3Client({});

const main = async () => {
  const input = {
    Bucket: "x-ray-aws-sample-12959-27997",
    Key: "dist.zip",
  };
  const command = new GetObjectCommand(input);
  const responseS3 = await s3Client.send(command);

  const saveBuffer = await fs.writeFile("dist/dist.zip", responseS3.Body);
  const buffer = await fs.readFile("dist/dist.zip");
  const wait = await decompress(buffer, "dummy");

  console.log("wait: ", wait);
};

main();
