import 'package:flutter/material.dart';
import 'package:iste/board/requests/widgets/requests_tiles.dart';
import 'package:iste/database/user_database.dart';
import 'package:iste/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApprovedRequestsScreen extends StatefulWidget {
  const ApprovedRequestsScreen({Key? key}) : super(key: key);

  @override
  _ApprovedRequestsScreenState createState() => _ApprovedRequestsScreenState();
}

class _ApprovedRequestsScreenState extends State<ApprovedRequestsScreen> {
  bool isLoading = true;
  late List data;
  late Map isActive;
  late List<User> user;

  Future getData() async {
    setState(() {
      isLoading = true;
    });

    String url = "https://vit-iste.herokuapp.com/4b6af54ccc566e082595080ad21d220d0124ee24ef2a9c3c33a82feff613aee3";

    http.Response response = await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    data = json.decode(response.body);

    setState(() {
      isLoading = false;
    });
    print(data);
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  void process(Map data) {
    String name = data["name"];
    int index = name.indexOf(" ") + 1;
    name = name.substring(0, index);
    data["name"] = name;
  }

  @override
  Widget build(BuildContext context) {
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
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0.0508 * c),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 0.0254 * c),
                            child: Text(
                              "Approved Requests",
                              style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 0.0772 * c),
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(right: 0.0508 * c),
                              child: Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 0.078 * c,
                              ),
                            ),
                            onTap: () => getData(),
                          )
                        ],
                      ),
                      SizedBox(height: 0.0508 * c),
                      data.length == 0 ? SizedBox(height: 0.254 * c) : SizedBox(),
                      data.length == 0
                          ? Center(
                              child: Text(
                                "No approved requests :(",
                                style: TextStyle(
                                  color: Colors.white30,
                                  fontFamily: "Poppins",
                                  fontSize: 0.0635 * c,
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 0.0508 * c, right: 0.0508 * c),
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (BuildContext ctx, index) {
                                    process(data[index]);
                                    return RequestTiles(data[index], "approved");
                                  },
                                  itemCount: data.length,
                                ),
                              ),
                            ),
                    ],
                  )));
  }
}
