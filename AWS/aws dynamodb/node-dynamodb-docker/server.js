
const express = require("express");
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const {
  DynamoDBDocumentClient,
  ScanCommand,
  PutCommand,
} = require("@aws-sdk/lib-dynamodb");

const app = express();
app.use(express.json());

const client = new DynamoDBClient({
  region: "eu-north-1",
});

const db = DynamoDBDocumentClient.from(client);
const TABLE_NAME = "contacts";
// Check whether the application is running
app.get("/", (req, res) => {
  res.send("Node.js + Docker + DynamoDB app is running!");
});

// Get all items from DynamoDB
app.get("/items", async (req, res) => {
  try {
    const result = await db.send(
      new ScanCommand({ TableName: TABLE_NAME })
    );

    res.json(result.Items || []);
  } catch (error) {
    console.error("DynamoDB read error:", error);
    res.status(500).json({ error: "Could not fetch items" });
  }
});

// Add an item to DynamoDB
app.post("/items", async (req, res) => {
  try {
    const { id, name } = req.body;

    if (!id || !name) {
      return res.status(400).json({
        error: "Both id and name are required",
      });
    }

    await db.send(
      new PutCommand({
        TableName: TABLE_NAME,
        Item: { id, name },
      })
    );

    res.status(201).json({
      message: "Item saved successfully",
      item: { id, name },
    });
  } catch (error) {
    console.error("DynamoDB write error:", error);
    res.status(500).json({ error: "Could not save item" });
  }
});

const PORT = 3000;

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
