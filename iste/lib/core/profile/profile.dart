import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iste/database/user_database.dart';
import 'package:iste/google_signin_api.dart';
import 'package:iste/models/user.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<User> user;
  int counter = 0;
  late String picture;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  bool isLoading = true;

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    user = await UserDatabase.instance.readAllUsers();
    picture = user[0].picture ?? "assets/images/cat.png";
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    refresh();
  }

  // @override
  // void dispose() {
  //   UserDatabase.instance.close();

  //   super.dispose();
  // }

  Future userSignOut(User user, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    firebaseMessaging.unsubscribeFromTopic("notify");
    firebaseMessaging.unsubscribeFromTopic("board");
    firebaseMessaging.unsubscribeFromTopic("core");
    await UserDatabase.instance.delete(user.id!);
    await GoogleSignInApi.logout();

    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    counter++;

    return Scaffold(
        backgroundColor: Colors.black,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Color.fromRGBO(141, 131, 252, 1),
              ))
            : Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 0.43 * c,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 0.39 * c,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(360),
                          child: picture == "assets/images/cat.png"
                              ? Image.asset(picture)
                              : Image.network(
                                  picture,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 0.0508 * c),
                  Container(
                    child: Text(
                      user[0].name.toString(),
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 0.065 * c,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 0.013 * c),
                  Container(
                    child: user[0].type == "core"
                        ? Text(
                            "ISTE - VIT Core Member",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 0.0468 * c,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "ISTE - VIT Board Member",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 0.0468 * c,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  Container(
                    child: user[0].type.toString() == "core"
                        ? Text(
                            user[0].domain.toString(),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 0.0468 * c,
                              color: Colors.white,
                            ),
                          )
                        : SizedBox(),
                  ),
                  SizedBox(height: 0.13 * c),
                  GestureDetector(
                    child: Container(
                      width: 0.286 * c,
                      height: 0.117 * c,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(141, 131, 252, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Sign Out",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 0.0468 * c,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () => userSignOut(user[0], context),
                  )
                ],
              ));
  }
}
