import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:iste/core/tasks/widgets/task_tiles.dart';
import 'package:iste/database/user_database.dart';
import 'package:iste/google_signin_api.dart';
import 'package:iste/models/user.dart';
import 'package:iste/update_app.dart';
import 'package:iste/version.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with AutomaticKeepAliveClientMixin<TasksScreen> {
  bool isLoading = true;
  late List data;
  late Map isActive;
  late List<User> user;
  late List version;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future checkUser() async {
    user = await UserDatabase.instance.readAllUsers();
    final String url = "https://vit-iste.herokuapp.com/52408ce928fcece4a50261fcbb1c3a1556b12bd3ad2c32ee0fd5a8d429b46193/" + user[0].email!;
    final response = await http.get(Uri.parse(url));
    isActive = json.decode(response.body);
    if (isActive["isActive"] == "no") {
      firebaseMessaging.unsubscribeFromTopic("notify");
      firebaseMessaging.unsubscribeFromTopic("core");
      await UserDatabase.instance.delete(user[0].id!);
      await GoogleSignInApi.logout();
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    } else {
      getData();
    }
  }

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
    firebaseMessaging.subscribeToTopic("core");
  }

  @override
  void initState() {
    super.initState();
    checkUser();
    checkVersion();
    subscribe();
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
                          margin: EdgeInsets.only(left: 0.0254 * c),
                          child: Text(
                            "Tasks",
                            style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 0.0772 * c),
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
                    data.length == 0 ? SizedBox(height: 0.254 * c) : SizedBox(),
                    data.length == 0
                        ? Center(
                            child: Text(
                              "No tasks left  :)",
                              style: TextStyle(
                                color: Colors.white30,
                                fontFamily: "Poppins",
                                fontSize: 0.0635 * c,
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
                )),
    );
  }
}
