import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class UpdateApp extends StatelessWidget {
  static const routeName = "/update-app";
  String link = "";

  void launchURL() {
    launch(link);
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    final route = ModalRoute.of(context);
    if (route == null)
      return SizedBox();
    else {
      final routeArgs = route.settings.arguments as Map<dynamic, dynamic>;
      link = routeArgs["link"];
    }

    Timer(const Duration(seconds: 3), () {
      launchURL();
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
                "Old version detected. Please wait while the latest apk is being downloaded.",
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
