import 'package:flutter/material.dart';
import 'package:iste/core/storage/file_deleted_screen.dart';
import 'package:iste/core/storage/firebase_api.dart';
import 'package:iste/core/storage/storage_screen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StorageTiles extends StatelessWidget {
  Map data;
  String type;
  StorageTiles(this.data, this.type);

  void customLaunch(String url) async {
    await launch(url);
  }

  Future deleteData(BuildContext context) async {
    final String url = "https://vit-iste.herokuapp.com/ff4085ad157354dc8ea67a848e7c2270b4a19282713cf3a7ecf8e0ffbb159ed1";
    final response = await http.delete(Uri.parse(url), body: {
      "id": data["_id"],
    });
    print(response.body);
    Navigator.of(context).pushNamed(FileDeletedScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    return data["type"] == type
        ? Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(141, 131, 252, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.only(top: 0.0508 * c),
            height: 0.3988 * c,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 0.009 * c),
                            child: Icon(
                              Icons.delete,
                              color: Color.fromRGBO(220, 64, 64, 1),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Color.fromRGBO(220, 64, 64, 1),
                                fontSize: 0.0416 * c,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        final snackBar = SnackBar(content: Text('Double tap to delete file permanently!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      onDoubleTap: () {
                        final snackBar = SnackBar(content: Text('Please wait, deleting file...'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        FirebaseApi.deleteFile(data["link"]);
                        deleteData(context);
                      },
                    ),
                    GestureDetector(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 0.009 * c),
                            child: Icon(
                              Icons.download, color: Colors.white, //Color.fromRGBO(180, 254, 152, 1),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Download",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white, //Color.fromRGBO(180, 254, 152, 1),
                                fontSize: 0.0416 * c,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () => customLaunch(data["link"]),
                    )
                  ],
                )
              ],
            ),
          )
        : SizedBox();
  }
}
