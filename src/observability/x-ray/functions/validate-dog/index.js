import { SendMessageCommand, SQSClient } from "@aws-sdk/client-sqs";

const client = new SQSClient({});
const SQS_QUEUE_URL = process.env.QUEUE_URL || 'queue_url';

export async function handler(event, context) {
    console.log("SQS_QUEUE_URL: ", SQS_QUEUE_URL);
    try {
        const body = JSON.parse(event.body);
        if(!body.dogName || typeof body.dogName !== 'string') {
            throw new Error("Name is required");
        }

        if(!body.dogBreed || typeof body.dogBreed !== 'string') {
            throw new Error("Breed is required");
        }

        if(!body.dogAge || typeof body.dogAge !== 'string') {
            throw new Error("Age is required");
        }

        if(!body.dogImage || typeof body.dogImage !== 'string') {
            throw new Error("Image is required");
        }

        const command = new SendMessageCommand({
            QueueUrl: SQS_QUEUE_URL,
            DelaySeconds: 10,
            MessageBody: event.body,
        });

        const response = await client.send(command);
        return {
            statusCode: 200,
            body: JSON.stringify(response),
        }
    } catch (error) {
        return {
            statusCode: 404,
            body: error.message,
        };
    }
};
