import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iste/board/requests/request_added_successfully_screen.dart';
import 'package:iste/board/requests/widgets/requests_tiles.dart';
import 'package:iste/board/tasks/success_task_screen.dart';
import 'package:iste/database/user_database.dart';
import 'package:iste/models/user.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

//https://vit-iste.herokuapp.com
class _RequestsScreenState extends State<RequestsScreen> with AutomaticKeepAliveClientMixin<RequestsScreen> {
  bool isLoading = true;
  late List data;
  late List<User> user;
  final requestController = TextEditingController();
  final titleController = TextEditingController();

  Future getData() async {
    setState(() {
      isLoading = true;
    });

    String url = "https://vit-iste.herokuapp.com/ec72420df5dfbdce4111f715c96338df3b7cb75f58e478d2449c9720e560de8c";

    http.Response response = await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    data = json.decode(response.body);

    setState(() {
      isLoading = false;
    });
    print(data);
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    user = await UserDatabase.instance.readAllUsers();
  }

  @override
  void initState() {
    super.initState();
    refresh();
    getData();
  }

  void process(Map data) {
    String name = data["name"];
    int index = name.indexOf(" ") + 1;
    name = name.substring(0, index);
    data["name"] = name;
  }

  Future sendData(String name, String title, String description, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final String url = "https://vit-iste.herokuapp.com/ec72420df5dfbdce4111f715c96338df3b7cb75f58e478d2449c9720e560de8c";
    final response = await http.post(Uri.parse(url), body: {
      "name": name,
      "title": title,
      "description": description,
    });
    print(response.body);
    print("data added!!!");
    Navigator.of(context).pushNamed(RequestAddedSuccessfully.routeName);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var c = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(141, 131, 252, 1),
                ),
              )
            : user[0].type == "core"
                ? SingleChildScrollView(
                    child: screenView(c, context),
                  )
                : screenView(c, context),
      ),
    );
  }

  Column screenView(double c, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 0.0508 * c),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 0.0254 * c),
              child: Text(
                "Requests",
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
            ),
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
                  child: Text(
                    "View approved requests",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 0.065 * c,
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () => Navigator.pushNamed(context, "/approved_requests_screen"),
        ),
        data.length == 0 && user[0].type == "board" ? SizedBox(height: 0.26 * c) : SizedBox(),
        data.length == 0 && user[0].type == "board"
            ? Center(
                child: Text(
                  "No new requests",
                  style: TextStyle(
                    color: Colors.white30,
                    fontFamily: "Poppins",
                    fontSize: 0.065 * c,
                  ),
                ),
              )
            : user[0].type == "board"
                ? Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 0.0508 * c, right: 0.0508 * c),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext ctx, index) {
                          process(data[index]);
                          return RequestTiles(data[index], "not approved");
                        },
                        itemCount: data.length,
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(left: 0.026 * c, right: 0.026 * c),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 0.15 * c,
                          padding: EdgeInsets.only(left: 0.027 * c, right: 0.027 * c),
                          margin: EdgeInsets.only(bottom: 0.054 * c),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(0.0405 * c)),
                            border: Border.all(color: Color.fromRGBO(141, 131, 252, 1), width: 0.0108 * c),
                          ),
                          child: TextField(
                            scrollPhysics: BouncingScrollPhysics(),
                            controller: titleController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintMaxLines: 10,
                              hintText: "Enter the title",
                              hintStyle: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.grey,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 0.45 * c,
                          padding: EdgeInsets.only(left: 0.027 * c, right: 0.027 * c),
                          margin: EdgeInsets.only(bottom: 0.054 * c),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(0.0405 * c)),
                            border: Border.all(color: Color.fromRGBO(141, 131, 252, 1), width: 0.0108 * c),
                          ),
                          child: TextField(
                            scrollPhysics: BouncingScrollPhysics(),
                            maxLines: null,
                            controller: requestController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintMaxLines: 10,
                              hintText: "Whatever you write here goes to all the members of the board. Once approved, only the title of the request becomes public",
                              hintStyle: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.grey,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 0.0508 * c),
                        GestureDetector(
                          child: Center(
                            child: Container(
                              width: 0.39 * c,
                              height: 0.117 * c,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(141, 131, 252, 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                  child: Text(
                                "Send Request",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 0.0468 * c,
                                  color: Colors.white,
                                ),
                              )),
                            ),
                          ),
                          onTap: () {
                            sendData(user[0].name.toString(), titleController.text, requestController.text, context);
                          },
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }
}
