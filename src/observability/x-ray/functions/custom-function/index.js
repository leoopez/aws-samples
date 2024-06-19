import {
  S3Client,
  GetObjectCommand,
  PutObjectCommand,
  DeleteObjectsCommand,
  ListObjectsCommand,
} from "@aws-sdk/client-s3";
import path from "path";
import { promises as fs } from "fs";
import decompress from "decompress";

import { send, SUCCESS, FAILED } from "./cfn-response";

const s3Client = new S3Client({});

const deleteAllObjectsFromBucket = async (bucket) => {
  const listCommand = new ListObjectsCommand({ Bucket: bucket });
  const listResponse = await s3Client.send(listCommand);
  console.log("List Objects response: ", listResponse);
  const objects = listResponse.Contents;
  if (objects && objects.length > 0) {
    const deleteParams = {
      Bucket: bucket,
      Delete: {
        Objects: objects.map((obj) => ({ Key: obj.Key })),
      },
    };

    const deleteCommand = new DeleteObjectsCommand(deleteParams);
    const deleteResponse = await s3Client.send(deleteCommand);
    console.log("Delete Objects response: ", deleteResponse);
  } else {
    console.log("Bucket is already empty");
  }
};

const recursiveUpload = async (dir, bucket, prefix) => {
  const files = await fs.readdir(dir);
  for (const file of files) {
    const filePath = path.join(dir, file);
    let key = prefix ? `${prefix}/${file}` : file;
    const stats = await fs.stat(filePath);
    if (stats.isFile()) {
      const body = await fs.readFile(filePath);
      const input = {
        Bucket: bucket,
        Key: key,
        Body: body,
      };

      const command = new PutObjectCommand(input);
      const response = await s3Client.send(command);
      console.log("Upload File response: ", response);
    } else if (stats.isDirectory()) {
      await recursiveUpload(filePath, bucket, key);
    }
  }
};

export const handler = async function (event, context) {
  try {
    console.log("Event: ", event);
    const { RequestType } = event;
    const { ResourceProperties } = event;
    const { BUCKET_TO_COPY_FROM, BUCKET_TO_COPY_FROM_KEY, BUCKET_TO_COPY_TO } =
      ResourceProperties;
    if (RequestType === "Create" || RequestType === "Update") {
      console.log(
        "Get Zip File From BUCKET_TO_COPY_FROM: ",
        BUCKET_TO_COPY_FROM
      );

      const input = {
        Bucket: BUCKET_TO_COPY_FROM,
        Key: BUCKET_TO_COPY_FROM_KEY,
      };

      const command = new GetObjectCommand(input);
      const responseS3 = await s3Client.send(command);
      console.log("Get Zip File response: ", responseS3);

      await fs.writeFile("/tmp/dist.zip", responseS3.Body);
      const buffer = await fs.readFile("/tmp/dist.zip");
      const unzipFiles = await decompress(buffer, "/tmp/dist");
      console.log("Unzip File /tmp", unzipFiles);

      console.log("Upload to S3 recursively");
      await recursiveUpload("/tmp/dist", BUCKET_TO_COPY_TO, "");
      const resultResponse = await send(event, context, SUCCESS);
      console.log("Result Response: ", resultResponse);
      return;
    }

    await deleteAllObjectsFromBucket(BUCKET_TO_COPY_TO);
    console.log("All S3 Deleted");

    const resultResponse = await send(event, context, SUCCESS);
    console.log("Result Response: ", resultResponse);
  } catch (error) {
    console.log("Error: ", error.message);
    const resultResponse = await send(event, context, FAILED);
    console.log("Result Response: ", resultResponse);
  }
};
