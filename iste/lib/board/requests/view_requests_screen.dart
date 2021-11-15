import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iste/board/requests/request_added_screen.dart';
import 'package:iste/board/requests/request_deleted_screen.dart';
import 'package:iste/database/user_database.dart';
import 'package:iste/models/user.dart';

class ViewRequestsScreen extends StatefulWidget {
  const ViewRequestsScreen({Key? key}) : super(key: key);

  @override
  _ViewRequestsScreenState createState() => _ViewRequestsScreenState();
}

class _ViewRequestsScreenState extends State<ViewRequestsScreen> {
  late Map data;
  bool isLoading = true;
  late List<User> user;
  int counter = 0;
  bool edit = false;

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

  @override
  void initState() {
    super.initState();

    refresh();
  }

  void process(Map data) {
    String name = data["name"];
    int index = name.indexOf(" ") + 1;
    name = name.substring(0, index);
    data["name"] = name;
  }

  Future deleteData(String id, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final String url = "https://vit-iste.herokuapp.com/ec72420df5dfbdce4111f715c96338df3b7cb75f58e478d2449c9720e560de8c";
    final response = await http.delete(Uri.parse(url), body: {
      "id": id,
    });
    print(response.body);
    print("data deleted!!!");
    Navigator.of(context).pushNamedAndRemoveUntil(RequestDeletedScreen.routeName, (route) => false);
  }

  Future approveData(String name, String description, String title, String id, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final String url = "https://vit-iste.herokuapp.com/4b6af54ccc566e082595080ad21d220d0124ee24ef2a9c3c33a82feff613aee3";
    final response = await http.post(
      Uri.parse(url),
      body: {
        "id": id,
        "name": name,
        "description": description,
        "title": title,
        "by": user[0].name,
      },
    );
    print(response.body);
    print("data added!!!");
    Navigator.of(context).pushNamedAndRemoveUntil(RequestAddedScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
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
                                "By: ",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 0.0508 * c,
                                ),
                              ),
                              Text(
                                data["name"],
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
                          data["description"],
                          style: TextStyle(fontFamily: "Poppins", color: Colors.white),
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
                                        width: 0.342 * c,
                                        height: 0.117 * c,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(54, 139, 133, 1),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Accept",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 0.0468 * c,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () => {approveData(data["name"], data["description"], data["title"], data["_id"], context)} //{deleteData(data["_id"], context)},
                                    ),
                                GestureDetector(
                                    child: Center(
                                      child: Container(
                                        width: 0.342 * c,
                                        height: 0.117 * c,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(230, 62, 109, 1),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Reject",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 0.0468 * c,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () => {deleteData(data["_id"], context)} //Navigator.pushNamed(context, "/new_task_screen", arguments: {"edit": true, "data": data}),
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
