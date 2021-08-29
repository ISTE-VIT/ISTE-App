const express = require("express");
const bodyParser = require("body-parser");
const fetch = require("node-fetch");
const mongoose = require("mongoose");

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

mongoose.connect(
  {key},
  { useNewUrlParser: true }
);

const userDataSchema = new mongoose.Schema({
  name: String,
  email: String,
  domain: String,
  type: String,
  isActive: String,
});

const taskSchema = new mongoose.Schema({
  task: String,
  deadline: String,
});

const broadcastSchema = new mongoose.Schema({
  name: String,
  description: String,
  dateTime: String,
});

const requestSchema = new mongoose.Schema({
  name: String,
  title: String,
  description: String,
});

const approvedRequestSchema = new mongoose.Schema({
  name: String,
  title: String,
  description: String,
  by: String,
});

const versionSchema = new mongoose.Schema({
  version: String,
  link: String,
});

const fileUploadSchema = new mongoose.Schema({
  name: String,
  uploadedBy: String,
  link: String,
  type: String,
});

app.post("/version", function (req, res) {
  const Data = mongoose.model("versions", versionSchema);
  const newData = new Data({
    version: req.body.version,
    link: req.body.link,
  });
  newData.save(function (err) {
    if (err) {
      console.log(err);
    } else {
      res.send("Version added successfully!");
    }
  });
});

app.get("/version", function (req, res) {
  const Data = mongoose.model("versions", versionSchema);
  Data.find({}, function (err, foundData) {
    if (err) {
      console.log(err);
    } else {
      res.send(foundData);
    }
  });
});

app.get(
  "/52408ce928fcece4a50261fcbb1c3a1556b12bd3ad2c32ee0fd5a8d429b46193/:email",
  function (req, res) {
    const Data = mongoose.model("userDatas", userDataSchema);
    Data.findOne(
      {
        email: req.params.email,
      },
      function (err, found) {
        if (err) {
          console.log(err);
        } else if (found) {
          res.send(found);
        } else {
          res.send("not found");
        }
      }
    );
  }
);

//////////////////////////////////POSTING TASKS////////////////////////
app.post(
  "/085154084c7427596104bc42f51f59f6d3ffd3d5f49f098210c20449fb7b2c71",
  function (req, res) {
    const Data = mongoose.model("tasks", taskSchema);
    const newData = new Data({
      task: req.body.task,
      deadline: req.body.deadline,
    });
    newData.save(function (err) {
      if (err) {
        console.log(err);
      } else {
        var notification = {
          title: "NEW TASK ADDED! Open app to view details!",
        };

        var notification_body = {
          to: "/topics/notify",
          notification: notification,
        };

        fetch("https://fcm.googleapis.com/fcm/send", {
          method: "POST",
          headers: {
            Authorization:
              "key=" +
              "AAAA9EVNLZM:APA91bEQlqynBqS4BHTlhqlqhsuJSyJPLW4VVUEUTRdhZ2aqkNx_ffdisdEL8VE1fFoI7Ncp38A5Czc7VsPU2lNXjnyOnYZZhg1wdJS0pHMFhDc_eS1D54fOKEj9lKcJ_evNYlLSNzXb",
            "Content-Type": "application/json",
          },
          body: JSON.stringify(notification_body),
        })
          .then(() => {
            console.log("Notification sent successfully!");
          })
          .catch((err) => {
            console.log(err);
          });

        res.send("Task added successfully!");
      }
    });
  }
);

//////////////////////////////////EDITING TASKS///////////////////////////
app.post(
  "/085154084c7427596104bc42f51f59f6d3ffd3d5f49f098210c20449fb7b2c71/edit",
  function (req, res) {
    const Data = mongoose.model("tasks", taskSchema);

    Data.deleteOne({ _id: req.body.id }, function (err, foundData) {
      if (err) {
        console.log(err);
      } else {
        console.log("Task deleted successfully!");
      }
    });

    const newData = new Data({
      task: req.body.task,
      deadline: req.body.deadline,
    });
    newData.save(function (err) {
      if (err) {
        console.log(err);
      } else {
        var notification = {
          title: "A TASK HAS BEEN EDITED! Open app to view details!",
        };

        var notification_body = {
          to: "/topics/notify",
          notification: notification,
        };
        fetch("https://fcm.googleapis.com/fcm/send", {
          method: "POST",
          headers: {
            Authorization:
              "key=" +
              "AAAA9EVNLZM:APA91bEQlqynBqS4BHTlhqlqhsuJSyJPLW4VVUEUTRdhZ2aqkNx_ffdisdEL8VE1fFoI7Ncp38A5Czc7VsPU2lNXjnyOnYZZhg1wdJS0pHMFhDc_eS1D54fOKEj9lKcJ_evNYlLSNzXb",
            "Content-Type": "application/json",
          },
          body: JSON.stringify(notification_body),
        })
          .then(() => {
            console.log("Notification sent successfully!");
          })
          .catch((err) => {
            console.log(err);
          });

        res.send("Task added successfully!");
      }
    });
  }
);

//////////////////////////////////GETTING TASKS////////////////////////
app.get(
  "/085154084c7427596104bc42f51f59f6d3ffd3d5f49f098210c20449fb7b2c71",
  function (req, res) {
    const Data = mongoose.model("tasks", taskSchema);
    Data.find()
      .sort({ _id: -1 })
      .exec(function (err, foundData) {
        if (err) {
          console.log(err);
        } else {
          res.send(foundData);
        }
      });
  }
);

////////////////////////////////////DELETING TASKS///////////////////////
app.delete(
  "/085154084c7427596104bc42f51f59f6d3ffd3d5f49f098210c20449fb7b2c71",
  function (req, res) {
    const Data = mongoose.model("tasks", taskSchema);
    Data.deleteOne({ _id: req.body.id }, function (err, foundData) {
      if (err) {
        console.log(err);
      } else {
        res.send("Task deleted successfully!");
      }
    });
  }
);

//////////////////////////////POSTING BROADCASTS/////////////////////
app.post(
  "/e8b13f8eebf238007d1aa38e4b57ac1d3bb8c3d5631ba826c9a81e9cd19c79b4",
  function (req, res) {
    const Data = mongoose.model("broadcasts", broadcastSchema);
    const newData = new Data({
      name: req.body.name,
      description: req.body.description,
      dateTime: req.body.dateTime,
    });
    newData.save(function (err) {
      if (err) {
        console.log(err);
      } else {
        var notification = {
          title: "NEW BROADCAST! Open app to view message!",
        };

        var notification_body = {
          to: "/topics/notify",
          notification: notification,
        };

        fetch("https://fcm.googleapis.com/fcm/send", {
          method: "POST",
          headers: {
            Authorization:
              "key=" +
              "AAAA9EVNLZM:APA91bEQlqynBqS4BHTlhqlqhsuJSyJPLW4VVUEUTRdhZ2aqkNx_ffdisdEL8VE1fFoI7Ncp38A5Czc7VsPU2lNXjnyOnYZZhg1wdJS0pHMFhDc_eS1D54fOKEj9lKcJ_evNYlLSNzXb",
            "Content-Type": "application/json",
          },
          body: JSON.stringify(notification_body),
        })
          .then(() => {
            console.log("Notification sent successfully!");
          })
          .catch((err) => {
            // res.status(400).send("Notification not sent!");
            console.log(err);
          });

        res.send("Broadcast added successfully!");
      }
    });
  }
);

//////////////////////////////GETTING BROADCASTS/////////////////////
app.get(
  "/e8b13f8eebf238007d1aa38e4b57ac1d3bb8c3d5631ba826c9a81e9cd19c79b4",
  function (req, res) {
    const Data = mongoose.model("broadcasts", broadcastSchema);

    Data.find()
      .sort({ _id: -1 })
      .exec(function (err, foundData) {
        if (err) {
          console.log(err);
        } else {
          res.send(foundData);
        }
      });
  }
);

//////////////////////////////////DELETING ALL BROADCASTS////////////////////////

app.get(
  "/6197595503f01ee2a34e403fe08d2e1d9d0c14cf1cdfc2b74739895dc9a15a04/broadcasts",
  function (req, res) {
    const Data = mongoose.model("broadcasts", broadcastSchema);
    Data.deleteMany(function (err) {
      if (!err) {
        res.send("Successfully deleted all broadcasts!");
      } else {
        res.send(err);
      }
    });
  }
);

/////////////////////////////////////DELETING ALL TASKS///////////////////////
app.get(
  "/6197595503f01ee2a34e403fe08d2e1d9d0c14cf1cdfc2b74739895dc9a15a04/tasks",
  function (req, res) {
    const Data = mongoose.model("tasks", taskSchema);
    Data.deleteMany(function (err) {
      if (!err) {
        res.send("Successfully deleted all tasks!");
      } else {
        res.send(err);
      }
    });
  }
);

////////////////////////////////////////////////POSTING REQUESTS////////////////////////////
app.post(
  "/ec72420df5dfbdce4111f715c96338df3b7cb75f58e478d2449c9720e560de8c",
  function (req, res) {
    const Data = mongoose.model("requests", requestSchema);
    const newData = new Data({
      name: req.body.name,
      title: req.body.title,
      description: req.body.description,
    });
    newData.save(function (err) {
      if (err) {
        console.log(err);
      } else {
        var notification = {
          title: "NEW REQUEST! Open app to view message!",
        };

        var notification_body = {
          to: "/topics/board",
          notification: notification,
        };

        fetch("https://fcm.googleapis.com/fcm/send", {
          method: "POST",
          headers: {
            Authorization:
              "key=" +
              "AAAA9EVNLZM:APA91bEQlqynBqS4BHTlhqlqhsuJSyJPLW4VVUEUTRdhZ2aqkNx_ffdisdEL8VE1fFoI7Ncp38A5Czc7VsPU2lNXjnyOnYZZhg1wdJS0pHMFhDc_eS1D54fOKEj9lKcJ_evNYlLSNzXb",
            "Content-Type": "application/json",
          },
          body: JSON.stringify(notification_body),
        })
          .then(() => {
            console.log("Notification sent successfully!");
          })
          .catch((err) => {
            // res.status(400).send("Notification not sent!");
            console.log(err);
          });

        res.send("Request added successfully!");
      }
    });
  }
);

/////////////////////////////DELETING A REQUEST/////////////////////////////////
app.delete(
  "/ec72420df5dfbdce4111f715c96338df3b7cb75f58e478d2449c9720e560de8c",
  function (req, res) {
    const Data = mongoose.model("requests", requestSchema);
    Data.deleteOne({ _id: req.body.id }, function (err, foundData) {
      if (err) {
        res.send(err);
      } else {
        res.send("Request deleted successfully!");
      }
    });
  }
);

/////////////////////////GETTING ALL REQUESTS////////////////////////////////////
app.get(
  "/ec72420df5dfbdce4111f715c96338df3b7cb75f58e478d2449c9720e560de8c",
  function (req, res) {
    const Data = mongoose.model("requests", requestSchema);
    Data.find({}, function (err, foundData) {
      if (err) {
        console.log(err);
      } else {
        res.send(foundData);
      }
    });
  }
);

/////////////////////////////////POSTING APPROVED REQUESTS/////////////////////
app.post(
  "/4b6af54ccc566e082595080ad21d220d0124ee24ef2a9c3c33a82feff613aee3",
  function (req, res) {
    const Data = mongoose.model("approvedRequests", approvedRequestSchema);

    const Data2 = mongoose.model("requests", requestSchema);
    Data2.deleteOne({ _id: req.body.id }, function (err, foundData) {
      if (err) {
        res.send(err);
      } else {
        console.log("Request deleted successfully!");
      }
    });

    const newData = new Data({
      name: req.body.name,
      description: req.body.description,
      title: req.body.title,
      by: req.body.by,
    });
    newData.save(function (err) {
      if (err) {
        console.log(err);
      } else {
        var notification = {
          title: "A REQUEST HAS BEEN APPROVED!",
        };

        var notification_body = {
          to: "/topics/core",
          notification: notification,
        };

        fetch("https://fcm.googleapis.com/fcm/send", {
          method: "POST",
          headers: {
            Authorization:
              "key=" +
              "AAAA9EVNLZM:APA91bEQlqynBqS4BHTlhqlqhsuJSyJPLW4VVUEUTRdhZ2aqkNx_ffdisdEL8VE1fFoI7Ncp38A5Czc7VsPU2lNXjnyOnYZZhg1wdJS0pHMFhDc_eS1D54fOKEj9lKcJ_evNYlLSNzXb",
            "Content-Type": "application/json",
          },
          body: JSON.stringify(notification_body),
        })
          .then(() => {
            console.log("Notification sent successfully!");
          })
          .catch((err) => {
            // res.status(400).send("Notification not sent!");
            console.log(err);
          });

        res.send("Request added successfully!");
      }
    });
  }
);

//////////////////////////GETTING ALL APPROVED REQUESTS////////////////////////
app.get(
  "/4b6af54ccc566e082595080ad21d220d0124ee24ef2a9c3c33a82feff613aee3",
  function (req, res) {
    const Data = mongoose.model("approvedRequests", approvedRequestSchema);
    Data.find()
      .sort({ _id: -1 })
      .exec(function (err, foundData) {
        if (err) {
          console.log(err);
        } else {
          res.send(foundData);
        }
      });
  }
);

/////////////////////////////DELETING ALL APPROVED REQUESTS//////////////////////
app.delete(
  "/4b6af54ccc566e082595080ad21d220d0124ee24ef2a9c3c33a82feff613aee3",
  function (req, res) {
    const Data = mongoose.model("approvedRequests", approvedRequestSchema);
    Data.deleteMany(function (err) {
      if (!err) {
        res.send("Successfully deleted all approved requests!");
      } else {
        res.send(err);
      }
    });
  }
);

///////////////////////////////////////POSTING CORE BROADCASTS////////////////////////
app.post(
  "/e8b13f8eebf238007d1aa38e4b57ac1d3bb8c3d5631ba826c9a81e9cd19c79b4/core",
  function (req, res) {
    const Data = mongoose.model("coreBroadcasts", broadcastSchema);
    const newData = new Data({
      name: req.body.name,
      description: req.body.description,
      dateTime: req.body.dateTime,
    });
    newData.save(function (err) {
      if (err) {
        console.log(err);
      } else {
        var notification = {
          title: "NEW CORE BROADCAST! Open app to view message!",
        };

        var notification_body = {
          to: "/topics/core",
          notification: notification,
        };

        fetch("https://fcm.googleapis.com/fcm/send", {
          method: "POST",
          headers: {
            Authorization:
              "key=" +
              "AAAA9EVNLZM:APA91bEQlqynBqS4BHTlhqlqhsuJSyJPLW4VVUEUTRdhZ2aqkNx_ffdisdEL8VE1fFoI7Ncp38A5Czc7VsPU2lNXjnyOnYZZhg1wdJS0pHMFhDc_eS1D54fOKEj9lKcJ_evNYlLSNzXb",
            "Content-Type": "application/json",
          },
          body: JSON.stringify(notification_body),
        })
          .then(() => {
            console.log("Notification sent successfully!");
          })
          .catch((err) => {
            // res.status(400).send("Notification not sent!");
            console.log(err);
          });

        res.send("Core Broadcast added successfully!");
      }
    });
  }
);

////////////////////////////////////////////GETTING CORE BROADCASTS/////////////
app.get(
  "/e8b13f8eebf238007d1aa38e4b57ac1d3bb8c3d5631ba826c9a81e9cd19c79b4/core",
  function (req, res) {
    const Data = mongoose.model("corebroadcasts", broadcastSchema);

    Data.find()
      .sort({ _id: -1 })
      .exec(function (err, foundData) {
        if (err) {
          console.log(err);
        } else {
          res.send(foundData);
        }
      });
  }
);

////////////////////POSTING FILES///////////////////
app.post(
  "/ff4085ad157354dc8ea67a848e7c2270b4a19282713cf3a7ecf8e0ffbb159ed1",
  function (req, res) {
    const Data = mongoose.model("files", fileUploadSchema);
    const newData = new Data({
      name: req.body.name,
      uploadedBy: req.body.uploadedBy,
      link: req.body.link,
      type: req.body.type,
    });
    newData.save(function (err) {
      if (err) {
        console.log(err);
      } else {
        var notification = {
          title: "A FILE HAS BEEN UPLOADED!",
          body: "Open the app to download the file.",
        };

        var notification_body = {
          to: "/topics/notify",
          notification: notification,
        };

        fetch("https://fcm.googleapis.com/fcm/send", {
          method: "POST",
          headers: {
            Authorization:
              "key=" +
              "AAAA9EVNLZM:APA91bEQlqynBqS4BHTlhqlqhsuJSyJPLW4VVUEUTRdhZ2aqkNx_ffdisdEL8VE1fFoI7Ncp38A5Czc7VsPU2lNXjnyOnYZZhg1wdJS0pHMFhDc_eS1D54fOKEj9lKcJ_evNYlLSNzXb",
            "Content-Type": "application/json",
          },
          body: JSON.stringify(notification_body),
        })
          .then(() => {
            console.log("Notification sent successfully!");
          })
          .catch((err) => {
            // res.status(400).send("Notification not sent!");
            console.log(err);
          });

        res.send("File added successfully!");
      }
    });
  }
);

//////////////////////////GETTING FILES/////////////
app.get(
  "/ff4085ad157354dc8ea67a848e7c2270b4a19282713cf3a7ecf8e0ffbb159ed1",
  function (req, res) {
    const Data = mongoose.model("files", fileUploadSchema);

    Data.find()
      .sort({ _id: -1 })
      .exec(function (err, foundData) {
        if (err) {
          console.log(err);
        } else {
          res.send(foundData);
        }
      });
  }
);

app.post("/notify", function (req, res) {
  var notification = {
    title: "Custom Notification",
    body: "This is a custom notification. Hope you all are attending all the classes :)",
  };

  var notification_body = {
    to: "/topics/board",
    notification: notification,
  };

  fetch("https://fcm.googleapis.com/fcm/send", {
    method: "POST",
    headers: {
      Authorization:
        "key=" +
        "AAAA9EVNLZM:APA91bEQlqynBqS4BHTlhqlqhsuJSyJPLW4VVUEUTRdhZ2aqkNx_ffdisdEL8VE1fFoI7Ncp38A5Czc7VsPU2lNXjnyOnYZZhg1wdJS0pHMFhDc_eS1D54fOKEj9lKcJ_evNYlLSNzXb",
      "Content-Type": "application/json",
    },
    body: JSON.stringify(notification_body),
  })
    .then(() => {
      console.log("Notification sent successfully!");
    })
    .catch((err) => {
      console.log(err);
    });

  res.send("Request added successfully!");
});

let port = process.env.PORT;
if (port == null || port == "") {
  port = 3000;
}

app.listen(port, function () {
  console.log("Server is running on port 3000!");
});
