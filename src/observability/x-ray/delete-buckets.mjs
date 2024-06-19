import {
  S3Client,
  ListBucketsCommand,
  ListObjectsCommand,
  DeleteBucketCommand,
  DeleteObjectCommand,
  ListObjectVersionsCommand,
} from "@aws-sdk/client-s3";

async function deleteAllBuckets() {
  try {
    const s3Client = new S3Client({ region: "us-west-1" });

    const input = {};
    const command = new ListBucketsCommand(input);
    const response = await s3Client.send(command);

    for (const bucket of response.Buckets) {
      let withObjects = false;
      try {
        const input = {
          // ListObjectsRequest
          Bucket: bucket.Name,
        };
        const command = new ListObjectsCommand(input);
        const response = await s3Client.send(command);
        console.log(response);
        if (response.Contents) {
          for (const content of response.Contents) {
            console.log("Deleting object:", content.Key);
            // DeleteObjectRequest
            const input = {
              Bucket: bucket.Name,
              Key: content.Key,
            };
            const command = new DeleteObjectCommand(input);
            const response = await s3Client.send(command);
            console.log(response.VersionId);
          }
        }

        const input2 = {
          // ListObjectVersionsRequest
          Bucket: bucket.Name,
        };
        const command2 = new ListObjectVersionsCommand(input2);
        const response2 = await s3Client.send(command2);
        console.log("response2", response2);
        if (response2.DeleteMarkers) {
          for (const content of response2.DeleteMarkers) {
            console.log("Deleting object:", content.Key);
            // DeleteObjectRequest
            const input = {
              Bucket: bucket.Name,
              Key: content.Key,
            };
            const command = new DeleteObjectCommand(input);
            const response = await s3Client.send(command);
            console.log(response.VersionId);
          }
        }
      } catch (error) {
        console.log("Error listing objects in bucket:", error);
        withObjects = true;
      }

      if (!withObjects) {
        try {
          console.log("Deleting bucket:", bucket.Name);
          // DeleteBucketRequest
          const input = {
            Bucket: bucket.Name,
          };
          const command = new DeleteBucketCommand(input);
          const response = await s3Client.send(command);
        } catch (error) {
          console.log("Error listing object versions in bucket:", error);
        }
      }
    }
  } catch (error) {
    console.error("Error deleting objects and buckets:", error);
  }
}

deleteAllBuckets();
