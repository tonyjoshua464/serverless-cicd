const express = require("express");
const AWS = require("aws-sdk");

const app = express();
const port = process.env.PORT || 3000;

AWS.config.update({ region: "us-east-1" });
const dynamoDB = new AWS.DynamoDB.DocumentClient();

app.get("/", (req, res) => {
    res.json({ message: "Serverless API Running on Fargate!" });
});

app.get("/data", async (req, res) => {
    const params = { TableName: "TestTable" };
    const data = await dynamoDB.scan(params).promise();
    res.json(data.Items);
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});