import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = "/sign-up";

  Widget coord(String name, String phone, String email, String img, var c) {
    return Column(
      children: [
        Container(
          // height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(360),
            child: Image.asset("assets/images/" + img + ".png"),
          ),
        ),
        SizedBox(height: 0.0254 * c),
        Container(
          child: Text(
            name,
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontSize: 0.04572 * c,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Container(
          child: Text(
            phone,
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontSize: 0.0381 * c,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Container(
          child: Text(
            email,
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontSize: 0.0381 * c,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: 0.0508 * c),
          Center(
            child: Container(
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontSize: 0.0635 * c,
                ),
              ),
            ),
          ),
          SizedBox(height: 0.0254 * c),
          Center(
            child: Container(
              child: Text(
                "Contact your student head to get started!",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontSize: 0.0381 * c,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          SizedBox(height: 0.0762 * c),
          coord("Jayesh Singh", "9790229917", "jayesh.singh2019@vitstudent.ac.in", "jayesh", c),
          SizedBox(height: 0.0762 * c),
          coord("Zaina Nizar", "8825991942", "zainajaffaree.nizar@vitstudent.ac.in", "zaina", c),
          SizedBox(height: 0.0762 * c),
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Have an account? ",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 0.0381 * c,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 0.0381 * c,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      )),
    );
  }
}
