import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:iste/board/broadcasts/success_broadcast_screen.dart';
import 'package:iste/database/user_database.dart';
import 'package:iste/models/user.dart';

class NewBroadcastScreen extends StatefulWidget {
  static const routeName = "/new-broadcast";

  @override
  _NewBroadcastScreenState createState() => _NewBroadcastScreenState();
}

class _NewBroadcastScreenState extends State<NewBroadcastScreen> {
  final broadcastController = TextEditingController();
  late List<User> user;
  bool isLoading = true;
  int counter = 0;
  String err = "";
  int errorStatus = 0;

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

  Future sendData(String description, BuildContext context) async {
    if (description.length < 5) {
      setState(() {
        err = "Please enter valid description";
        errorStatus = 1;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    final String url = "https://vit-iste.herokuapp.com/e8b13f8eebf238007d1aa38e4b57ac1d3bb8c3d5631ba826c9a81e9cd19c79b4";
    final response = await http.post(Uri.parse(url), body: {
      "name": user[0].name,
      "description": description,
      "dateTime": DateFormat("HH:mm, dd/MM/yyyy").format(DateTime.now()),
    });
    print(response.body);
    print("data added!!!");
    Navigator.of(context).pushNamedAndRemoveUntil(SuccessBroadcastScreen.routeName, (route) => false);
  }

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    counter++;
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
                : SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(left: 0.026 * c, right: 0.026 * c),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 0.13 * c),
                          Container(
                            child: Text(
                              "New Broadcast",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 0.065 * c,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 0.0508 * c),
                          Container(
                            height: 0.65 * c,
                            padding: EdgeInsets.only(left: 0.027 * c, right: 0.027 * c),
                            margin: EdgeInsets.only(bottom: 0.054 * c),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(0.0405 * c)),
                              border: Border.all(color: Color.fromRGBO(141, 131, 252, 1), width: 0.0108 * c),
                            ),
                            child: TextField(
                              scrollPhysics: BouncingScrollPhysics(),
                              maxLines: null,
                              controller: broadcastController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter the message",
                                hintStyle: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.grey,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 0.0508 * c),
                          GestureDetector(
                            child: Center(
                              child: Container(
                                width: 0.39 * c,
                                height: 0.117 * c,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(141, 131, 252, 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    "Send to all",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 0.0468 * c,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => {sendData(broadcastController.text, context)},
                          ),
                          SizedBox(height: 0.0508 * c),
                          errorStatus != 0
                              ? Center(
                                  child: Container(
                                    child: Text(
                                      err,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.white,
                                        fontSize: 0.0416 * c,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  )));
  }
}
