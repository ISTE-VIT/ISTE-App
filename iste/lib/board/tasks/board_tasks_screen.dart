import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iste/board/tasks/new_task_screen.dart';
import 'dart:convert';

import 'package:iste/core/tasks/widgets/task_tiles.dart';
import 'package:iste/update_app.dart';
import 'package:iste/version.dart';

class BoardTasksScreen extends StatefulWidget {
  const BoardTasksScreen({Key? key}) : super(key: key);

  @override
  _BoardTasksScreenState createState() => _BoardTasksScreenState();
}

class _BoardTasksScreenState extends State<BoardTasksScreen> with AutomaticKeepAliveClientMixin<BoardTasksScreen> {
  bool isLoading = true;
  late List data;
  late List version;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future checkVersion() async {
    setState(() {
      isLoading = true;
    });

    String url = "https://vit-iste.herokuapp.com/version";

    http.Response response = await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    version = json.decode(response.body);

    if (version[0]["version"] != VERSION) {
      print(version[0]["link"]);
      Navigator.of(context).pushReplacementNamed(UpdateApp.routeName, arguments: {"link": version[0]["link"]});
    }
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });

    String url = "https://vit-iste.herokuapp.com/085154084c7427596104bc42f51f59f6d3ffd3d5f49f098210c20449fb7b2c71";

    http.Response response = await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    data = json.decode(response.body);

    setState(() {
      isLoading = false;
    });
    print(data);
  }

  Future subscribe() async {
    firebaseMessaging.subscribeToTopic("notify");
    firebaseMessaging.subscribeToTopic("board");
  }

  @override
  void initState() {
    super.initState();

    checkVersion();
    subscribe();
    getData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var c = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(141, 131, 252, 1),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0.0508 * c),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0.026 * c),
                        child: Text(
                          "Tasks",
                          style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 0.078 * c),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(right: 0.0508 * c),
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 0.078 * c,
                          ),
                        ),
                        onTap: () => getData(),
                      )
                    ],
                  ),
                  SizedBox(height: 0.0508 * c),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(left: 0.026 * c, right: 0.026 * c, bottom: 0.0508 * c),
                      width: 1.04 * c,
                      height: 0.26 * c,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Icon(Icons.add, size: 0.078 * c),
                          ),
                          Container(
                            child: Text(
                              "Add a new task",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 0.065 * c,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () => Navigator.pushNamed(context, "/new_task_screen", arguments: {"edit": false}),
                  ),
                  data.length == 0 ? SizedBox(height: 0.26 * c) : SizedBox(),
                  data.length == 0
                      ? Center(
                          child: Text(
                            "No tasks left  :)",
                            style: TextStyle(
                              color: Colors.white30,
                              fontFamily: "Poppins",
                              fontSize: 0.065 * c,
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 0.0508 * c, right: 0.0508 * c),
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext ctx, index) {
                                return TaskTiles(data[index]);
                              },
                              itemCount: data.length,
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
