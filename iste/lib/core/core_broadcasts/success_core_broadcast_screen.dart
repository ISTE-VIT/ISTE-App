import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iste/core/home_screen.dart';

class SuccessCoreBroadcastScreen extends StatelessWidget {
  static const routeName = "/success-core-broadcast";

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
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
                "New message broadcasted successfully! Redirecting to home-screen.",
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
