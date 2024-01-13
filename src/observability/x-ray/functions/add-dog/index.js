import { DynamoDBClient, BatchWriteItemCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({});
const TABLE_NAME = process.env.TABLE_NAME || 'DogsTable';

export async function handler(event, context) {
    try {
        const body = JSON.parse(event.Records[0].body);
        const input = {
            "RequestItems": {
                [TABLE_NAME]: [
                    {
                        "PutRequest": {
                            "Item": {
                                "Name": {
                                    "S": body.dogName
                                },
                                "Breed": {
                                    "S": body.dogBreed
                                },
                                "Age": {
                                    "N": body.dogAge
                                },
                                "Image": {
                                    "S": body.dogImage
                                }
                            }
                        }
                    },
                ]
            }
        };

        const command = new BatchWriteItemCommand(input);
        const response = await client.send(command);
        return response;
    } catch (error) {
        return {
            statusCode: 404,
            body: error.message,
        };
    }
};