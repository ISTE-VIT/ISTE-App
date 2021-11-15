import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iste/board/broadcasts/success_broadcast_screen.dart';
import 'package:iste/board/tasks/success_task_screen.dart';
import 'dart:convert';

import 'package:iste/core/storage/widgets/storage_tiles.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  _StorageScreenState createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> with AutomaticKeepAliveClientMixin<StorageScreen> {
  bool isLoading = false;
  int selectedPageIndex = 0;
  List data = [];
  List type = ["Permission", "Report", "Other"];

  void process(Map data) {
    String name = data["uploadedBy"];
    int index = name.indexOf(" ") + 1;
    name = name.substring(0, index);
    data["uploadedBy"] = name;
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });

    String url = "https://vit-iste.herokuapp.com/ff4085ad157354dc8ea67a848e7c2270b4a19282713cf3a7ecf8e0ffbb159ed1";

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

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var c = MediaQuery.of(context).size.width;
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
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
                                "Storage",
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
                                  child: Icon(Icons.cloud_upload, size: 0.078 * c),
                                ),
                                Container(
                                  child: Text(
                                    "Upload a new file",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 0.065 * c,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () => {Navigator.pushNamed(context, "/upload_new_file_screen")},
                        ),
                        TabBar(
                          indicatorColor: Colors.white,
                          onTap: selectPage,
                          isScrollable: false,
                          tabs: [
                            Tab(
                              child: Text("Permissions", style: TextStyle(color: Colors.white, fontFamily: "Poppins")),
                            ),
                            Tab(
                              child: Text("Reports", style: TextStyle(color: Colors.white, fontFamily: "Poppins")),
                            ),
                            Tab(
                              child: Text("Others", style: TextStyle(color: Colors.white, fontFamily: "Poppins")),
                            )
                          ],
                        ),
                        data.length == 0 ? SizedBox(height: 0.26 * c) : SizedBox(),
                        data.length == 0
                            ? Center(
                                child: Text(
                                  "No files :(",
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
                                      process(data[index]);
                                      return StorageTiles(data[index], type[selectedPageIndex]);
                                    },
                                    // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 0.5 * c, childAspectRatio: 2.5 / 2.3, crossAxisSpacing: 0.05 * c, mainAxisSpacing: 25),
                                    itemCount: data.length,
                                  ),
                                ),
                              ),
                      ],
                    ))),
    );
  }
}
