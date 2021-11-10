import 'package:flutter/material.dart';
import 'package:iste/core/tasks/task_deleted_screen.dart';
import 'package:iste/database/user_database.dart';
import 'package:iste/models/user.dart';
import 'package:http/http.dart' as http;

class TaskDetailsScreen extends StatefulWidget {
  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late Map data;
  bool isLoading = true;
  late List<User> user;
  int counter = 0;
  bool edit = false;

  void process(Map data) {
    String name = data["givenBy"];
    int index = name.indexOf(" ") + 1;
    name = name.substring(0, index);
    data["givenBy"] = name;
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    user = await UserDatabase.instance.readAllUsers();
    if (this.user.isEmpty && counter == 1) {
      ////////////////////do st
    }
    setState(() {
      isLoading = false;
    });
  }

  Future deleteData(String id, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    //https://vit-iste.herokuapp.com/085154084c7427596104bc42f51f59f6d3ffd3d5f49f098210c20449fb7b2c71
    final String url = "https://vit-iste.herokuapp.com/085154084c7427596104bc42f51f59f6d3ffd3d5f49f098210c20449fb7b2c71";
    final response = await http.delete(Uri.parse(url), body: {
      "id": id,
    });
    print(response.body);
    print("data deleted!!!");
    Navigator.of(context).pushNamedAndRemoveUntil(TaskDeletedScreen.routeName, (route) => false);
  }

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    counter++;
    final route = ModalRoute.of(context);
    if (route == null)
      return SizedBox();
    else {
      final routeArgs = route.settings.arguments as Map<dynamic, dynamic>;
      data = routeArgs["data"];
      process(data);
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(141, 131, 252, 1),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0.13 * c),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                          padding: EdgeInsets.only(right: 0.0508 * c),
                          margin: EdgeInsets.only(left: 0.0508 * c),
                          child: Row(
                            children: [
                              Text(
                                "Deadline: ",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 0.0508 * c,
                                ),
                              ),
                              Text(
                                data["deadline"],
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontSize: 0.0508 * c,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 0.0508 * c),
                      Container(
                        width: 1.04 * c,
                        margin: EdgeInsets.only(left: 0.0508 * c, right: 0.0508 * c),
                        padding: EdgeInsets.all(0.0508 * c),
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          data["task"],
                          style: TextStyle(fontFamily: "Poppins", color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 0.0510 * c, top: 0.0510 * c),
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                "Assigned by: ",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 0.0408 * c,
                                ),
                              ),
                            ),
                            Container(
                                child: Text(
                              data["givenBy"],
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontSize: 0.0408 * c,
                              ),
                            )),
                          ],
                        ),
                      ),
                      user[0].type == "board" ? SizedBox(height: 0.0508 * c) : SizedBox(),
                      user[0].type == "board"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  child: Center(
                                    child: Container(
                                      width: 0.442 * c,
                                      height: 0.117 * c,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(141, 131, 252, 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Delete this task",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 0.0468 * c,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () => {deleteData(data["_id"], context)},
                                ),
                                GestureDetector(
                                  child: Center(
                                    child: Container(
                                      width: 0.442 * c,
                                      height: 0.117 * c,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(141, 131, 252, 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Edit this task",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 0.0468 * c,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () => Navigator.pushNamed(context, "/new_task_screen", arguments: {"edit": true, "data": data}),
                                )
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                )),
    );
  }
}
