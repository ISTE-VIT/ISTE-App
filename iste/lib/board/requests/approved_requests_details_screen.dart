import 'package:flutter/material.dart';
import 'package:iste/database/user_database.dart';
import 'package:iste/models/user.dart';

class ApprovedRequestDetailsScreen extends StatefulWidget {
  @override
  _ApprovedRequestDetailsScreenState createState() => _ApprovedRequestDetailsScreenState();
}

class _ApprovedRequestDetailsScreenState extends State<ApprovedRequestDetailsScreen> {
  late Map data;
  late List<User> user;

  bool isLoading = true;

  void process(Map data) {
    String name = data["name"];
    int index = name.indexOf(" ") + 1;
    name = name.substring(0, index);
    data["name"] = name;
    name = data["by"];
    index = name.indexOf(" ") + 1;
    name = name.substring(0, index);
    data["by"] = name;
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    user = await UserDatabase.instance.readAllUsers();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    refresh();
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
                            data["title"],
                            style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 0.051 * c),
                          )),
                      SizedBox(height: user[0].type == "board" ? 0.0508 * c : 0),
                      user[0].type == "board"
                          ? Container(
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
                              ))
                          : SizedBox(),
                      SizedBox(height: 0.0508 * c),
                      Container(
                        padding: EdgeInsets.only(right: 0.0508 * c),
                        margin: EdgeInsets.only(left: 0.0508 * c),
                        child: Row(
                          children: [
                            Text(
                              "Approved by: ",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 0.0508 * c,
                              ),
                            ),
                            Text(
                              data["by"],
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontSize: 0.0508 * c,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}
