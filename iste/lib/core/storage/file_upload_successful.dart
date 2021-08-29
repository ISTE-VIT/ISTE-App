import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iste/board/board_home_screen.dart';
import 'package:iste/core/home_screen.dart';
import 'package:iste/database/user_database.dart';
import 'package:iste/models/user.dart';

class FileUploadSuccessful extends StatefulWidget {
  static const routeName = "/success-file-upload";

  @override
  _FileUploadSuccessfulState createState() => _FileUploadSuccessfulState();
}

class _FileUploadSuccessfulState extends State<FileUploadSuccessful> {
  late List<User> user;
  bool isLoading = true;
  int counter = 0;

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
    counter++;
    if (counter == 1) {
      Timer(const Duration(seconds: 2), () {
        if (user[0].type == "core") {
          Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(BoardHomeScreen.routeName, (route) => false);
        }
      });
    }
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(141, 131, 252, 1),
                      ),
                    )
                  : Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 0.0508 * c, right: 0.0508 * c),
                        child: Text(
                          "File added successfully!",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 0.065 * c,
                            color: Color.fromRGBO(141, 131, 252, 1),
                          ),
                        ),
                      ),
                    )),
        ));
  }
}
