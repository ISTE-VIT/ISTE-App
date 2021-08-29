import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iste/core/broadcasts/widgets/broadcast_tiles.dart';

class BroadcastsScreen extends StatefulWidget {
  const BroadcastsScreen({Key? key}) : super(key: key);

  @override
  _BroadcastsScreenState createState() => _BroadcastsScreenState();
}

class _BroadcastsScreenState extends State<BroadcastsScreen> with AutomaticKeepAliveClientMixin<BroadcastsScreen> {
  bool isLoading = true;

  late List data;

  Future getData() async {
    setState(() {
      isLoading = true;
    });

    String url = "https://vit-iste.herokuapp.com/e8b13f8eebf238007d1aa38e4b57ac1d3bb8c3d5631ba826c9a81e9cd19c79b4";

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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                          margin: EdgeInsets.only(left: 0.026 * c),
                          child: Text(
                            "Broadcasts",
                            style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 0.078 * c),
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
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: 0.026 * c, right: 0.026 * c, bottom: 0.0508 * c),
                        width: 1.04 * c,
                        height: 0.26 * c,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Icon(Icons.announcement, size: 0.078 * c),
                            ),
                            Container(
                              child: Text(
                                "Core Broadcasts",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 0.065 * c,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () => {Navigator.pushNamed(context, "/core_broadcast_screen")},
                    ),
                    data.length == 0 ? SizedBox(height: 0.26 * c) : SizedBox(),
                    data.length == 0
                        ? Center(
                            child: Text(
                              "No new broadcasts :)",
                              style: TextStyle(
                                color: Colors.white30,
                                fontFamily: "Poppins",
                                fontSize: 0.065 * c,
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 0.026 * c, right: 0.026 * c),
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (BuildContext ctx, index) {
                                  return BroadcastTiles(data[index]);
                                },
                                // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 0.5 * c, childAspectRatio: 2.5 / 2.3, crossAxisSpacing: 0.05 * c, mainAxisSpacing: 25),
                                itemCount: data.length,
                              ),
                            ),
                          ),
                  ],
                )),
    );
  }
}
