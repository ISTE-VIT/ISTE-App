const ejs = require("ejs");
const express = require("express");

const app = express();

app.set("view engine", "ejs");
app.use(express.static("public"));

app.use("/api/notification", require("./routes/api/notification"));

let port = process.env.PORT;
if (port == null || port == "") {
    port = 3000;
}

app.listen(port, function(){
    console.log("Server is running!");
});