const express = require("express");
const fetch  = require("node-fetch");

const router = express.Router();

router.post("/task", (req, res) => {
var notification = {
    "title" : "New data added!",
    "text" : "Description comes here!",
};


var notification_body = {
    "to" : "/topics/notify",
    "notification" : notification,
}

    fetch("https://fcm.googleapis.com/fcm/send", {
        "method" : "POST",
        "headers" : {
            "Authorization" : "key=" + "AAAAFBLdjoM:APA91bEy6jPeKHULv0NsF2H8JdRa2s6Kry75-fwZYzcNBh3yn9cW6ELHb_HfKgp8m-Ge9uGR2yCE3XAsJUx5exXOThhu7VP353l3twju3s480kCDP5c_0muqxNTVO1e3JycGxXiX-Q5W",
            "Content-Type" : "application/json"
        },
        "body" : JSON.stringify(notification_body),
    }).then(() => {
        res.status(200).send("Notification sent successfully!");
    }).catch((err) => {
        res.status(400).send("Notification not sent!");
        console.log(err);
    })
});

module.exports = router