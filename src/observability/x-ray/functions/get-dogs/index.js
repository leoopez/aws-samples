import { DynamoDBClient, ScanCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({});
const TABLE_NAME = process.env.TABLE_NAME || 'DogsTable';

exports.handler = async (event, context) => {
    try {
        const command = new ScanCommand({
            TableName: TABLE_NAME,
        })

        const response = await client.send(command);
        const mappedItems = response.Items.map((element) => {
            return {
                name: element.Name.S,
                breed: element.Breed.S,
                age: element.Age.N,
                image: element.Image.S,
            }
        });

        return {
            statusCode: 200,
            body: JSON.stringify(mappedItems),
        }
    } catch (error) {
        return {
            statusCode: 404,
            body: error.message,
        };
    }
};
