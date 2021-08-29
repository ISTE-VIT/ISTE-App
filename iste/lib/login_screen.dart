import 'package:flutter/material.dart';
import 'package:iste/board/board_home_screen.dart';
import 'package:iste/core/home_screen.dart';
import 'package:iste/database/user_database.dart';
import 'package:iste/google_signin_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iste/models/user.dart';
import 'package:iste/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int counter = 0;
  bool isLoading = false;
  late List<User> user;
  late Map data;

  Future getData(String email, String? pictureAddress) async {
    final String url = "https://vit-iste.herokuapp.com/52408ce928fcece4a50261fcbb1c3a1556b12bd3ad2c32ee0fd5a8d429b46193/" + email;
    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.body != "not found") {
      data = json.decode(response.body);
      if (data["type"] == "core") {
        final user = User(name: data["name"], email: data["email"], domain: data["domain"], type: data["type"], picture: pictureAddress);
        await UserDatabase.instance.create(user);

        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } else {
        final user = User(name: data["name"], email: data["email"], domain: data["domain"], type: data["type"], picture: pictureAddress);
        await UserDatabase.instance.create(user);

        Navigator.of(context).pushReplacementNamed(BoardHomeScreen.routeName);
      }
    } else {
      await GoogleSignInApi.logout();
      Navigator.of(context).pushNamed(SignUpScreen.routeName);
    }
  }

  Future signIn(BuildContext context) async {
    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign in Failed")));
    } else {
      print(user.displayName);
      print(user.email);
      print(user.id);
      print(user.photoUrl);
      getData(user.email, user.photoUrl);
    }
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    this.user = await UserDatabase.instance.readAllUsers();
    if (!this.user.isEmpty && counter == 1) {
      if (user[0].type.toString() == "core") {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(BoardHomeScreen.routeName);
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 150,
                  // ),
                  Container(
                    child: Image.asset("assets/images/iste_logo.png"),
                  ),
                  SizedBox(height: 0.0762 * c),
                  GestureDetector(
                    child: Container(
                      width: 0.762 * c,
                      height: 0.127 * c,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(141, 131, 252, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 0.0889 * c,
                            child: Image.asset("assets/images/google.png"),
                          ),
                          Text(
                            "Login with Google",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 0.0508 * c,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => signIn(context),
                  )
                ],
              ),
      ),
    );
  }
}
