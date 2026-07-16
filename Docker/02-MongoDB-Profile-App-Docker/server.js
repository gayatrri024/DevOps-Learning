const express = require("express");
const path = require("path");
const { MongoClient } = require("mongodb");
const bodyParser = require("body-parser");

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

const url = "mongodb://admin:password@localhost:27017";

app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "index.html"));
});

app.get("/profile-picture", (req, res) => {
    res.sendFile(path.join(__dirname, "profile-1.jpg"));
});

app.get("/get-profile", async (req, res) => {

    const client = new MongoClient(url);

    try {

        await client.connect();

        const db = client.db("user-account");

        const user = await db.collection("users").findOne({ userid: 1 });
         res.send(user);

    } catch (err) {

        console.error(err);
        res.status(500).send(err);

    } finally {

        await client.close();

    }

});

app.post("/update-profile", async (req, res) => {

    const client = new MongoClient(url);

    try {

        await client.connect();

        const db = client.db("user-account");

        await db.collection("users").updateOne(
            { userid: 1 },
            {
                $set: {
                    name: req.body.name,
                    email: req.body.email,
                    interests: req.body.interests
                }
            }
        );

        res.send("Profile updated successfully");

    } catch (err) {

        console.error(err);
        res.status(500).send(err);

    } finally {

        await client.close();

    }

});

app.listen(3000, () => {
    console.log("Server running on port 3000");
});