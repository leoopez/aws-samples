import fs from 'fs';
import path from 'path';

const HTML_FILE_NAME = "./index.html";
const fileContent = fs.readFileSync(path.resolve(__dirname, HTML_FILE_NAME), 'utf8');

export async function handler(event, context) {
    try {
        return {
            'statusCode': 200,
            'body': fileContent,
            "headers": {"Content-type": "text/html"}
        }
    } catch (error) {
        return {
            statusCode: 404,
            body: error.message,
        };
    }
};
