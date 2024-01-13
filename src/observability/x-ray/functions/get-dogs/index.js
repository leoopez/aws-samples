import { DynamoDBClient, ScanCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({});
const TABLE_NAME = "dogs";

exports.handler = async (event, context) => {
    try {
        const command = new ScanCommand({
            TableName: TABLE_NAME,
        })

        const response = await client.send(command);
        return response;
    } catch (error) {
        return {
            statusCode: 404,
            body: error.message,
        };
    }
};
