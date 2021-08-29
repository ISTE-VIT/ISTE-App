import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StorageTiles extends StatelessWidget {
  Map data;
  String type;
  StorageTiles(this.data, this.type);

  void customLaunch(String url) async {
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    return data["type"] == type
        ? GestureDetector(
            onTap: () {
              customLaunch(data["link"]);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(141, 131, 252, 1),
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.only(top: 0.0508 * c),
              height: 0.3048 * c,
              width: 0.13 * c,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 0.052 * c, right: 0.052 * c), //0.0254 * c //0.026 * c
                      height: 0.125 * c,
                      child: Text(
                        data["name"],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 0.0416 * c,
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 0.0254 * c, bottom: 0.026 * c, right: 0.052 * c),
                          child: Text(
                            "Uploaded by: " + data["uploadedBy"],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white60,
                              fontSize: 0.0416 * c,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }
}
