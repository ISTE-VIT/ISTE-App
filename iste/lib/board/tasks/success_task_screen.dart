import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iste/board/board_home_screen.dart';

class SuccessTaskScreen extends StatelessWidget {
  static const routeName = "/success-task";

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushNamedAndRemoveUntil(BoardHomeScreen.routeName, (route) => false);
    });
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
              child: Center(
            child: Container(
              margin: EdgeInsets.only(left: 0.0508 * c, right: 0.0508 * c),
              child: Text(
                "Task added successfully! Redirecting you to the home-screen",
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
