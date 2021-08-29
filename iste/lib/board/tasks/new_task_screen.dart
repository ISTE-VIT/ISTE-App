import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iste/board/tasks/success_task_screen.dart';
import 'package:intl/intl.dart';

class NewTaskScreen extends StatefulWidget {
  static const routeName = "/new-task-screen";

  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final taskController = TextEditingController();
  String err = "";
  int errorStatus = 0;
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool timeSelected = false;
  String timeText = "";
  bool edit = false;
  bool editLabel = true;
  bool dateEdit = false;
  bool timeEdit = false;
  late Map data;
  String selectedDateString = "";
  String selectedTimeString = "";
  int counter = 0;

  Future<void> _selectDate(BuildContext context) async {
    dateEdit = false;
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2030));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    timeEdit = false;
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now()); //  (context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2030));
    if (picked != null)
      setState(() {
        timeSelected = true;
        selectedTime = picked;
      });
  }

  Future sendData(String task, String date, String time, BuildContext context) async {
    if (task.length < 5) {
      setState(() {
        err = "Please enter valid task details";
        errorStatus = 1;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    final String url = "https://vit-iste.herokuapp.com/085154084c7427596104bc42f51f59f6d3ffd3d5f49f098210c20449fb7b2c71";
    String deadline;
    if (timeSelected) {
      deadline = date + " before " + time;
    } else {
      deadline = date;
    }
    final response = await http.post(Uri.parse(url), body: {
      "task": task,
      "deadline": deadline,
    });
    print(response.body);
    print("data added!!!");
    Navigator.of(context).pushNamed(SuccessTaskScreen.routeName);
  }

  Future editData(String task, String date, String time, String id, BuildContext context) async {
    if (dateEdit == true) {
      date = selectedDateString;
    }
    if (timeEdit == true) {
      time = selectedTimeString;
    }
    if (task.length < 5) {
      setState(() {
        err = "Please enter valid task details";
        errorStatus = 1;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    final String url = "https://vit-iste.herokuapp.com/085154084c7427596104bc42f51f59f6d3ffd3d5f49f098210c20449fb7b2c71/edit";
    String deadline;
    if (time != "") {
      deadline = date + " before " + time;
    } else {
      deadline = date;
    }
    final response = await http.post(Uri.parse(url), body: {
      "id": id,
      "task": task,
      "deadline": deadline,
    });
    print(response.body);
    print("data added!!!");
    Navigator.of(context).pushNamed(SuccessTaskScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    counter++;
    final route = ModalRoute.of(context);
    if (route == null)
      return SizedBox();
    else {
      final routeArgs = route.settings.arguments as Map<dynamic, dynamic>;
      if (routeArgs["edit"] == true && counter == 1) {
        edit = true;
        editLabel = routeArgs["edit"];
        dateEdit = true;
        timeEdit = true;
        data = routeArgs["data"];
        taskController.text = data["task"];
        selectedDateString = data["deadline"].substring(0, 10);
        if (data["deadline"].length > 10) {
          selectedTimeString = data["deadline"].substring(18);
        }
        print(selectedDateString);
        print(selectedTimeString);
        print(edit);
      }
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SafeArea(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(141, 131, 252, 1),
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(left: 0.026 * c, right: 0.026 * c),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 0.13 * c),
                          Container(
                            child: !edit
                                ? Text(
                                    "Add a task",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 0.065 * c,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Edit task",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 0.065 * c,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          SizedBox(height: 0.0508 * c),
                          Container(
                            height: 0.65 * c,
                            padding: EdgeInsets.only(left: 0.027 * c, right: 0.027 * c),
                            margin: EdgeInsets.only(bottom: 0.054 * c),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(0.0405 * c)),
                              border: Border.all(color: Color.fromRGBO(141, 131, 252, 1), width: 0.0108 * c),
                            ),
                            child: TextField(
                              scrollPhysics: BouncingScrollPhysics(),
                              maxLines: null,
                              controller: taskController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintMaxLines: 10,
                                hintText: "Enter the task description(minimum length is 5)",
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
                          // SizedBox(height: 0.0508 * c),
                          Container(
                            height: 0.208 * c,
                            padding: EdgeInsets.only(left: 0.027 * c, right: 0.027 * c),
                            margin: EdgeInsets.only(bottom: 0.054 * c),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(0.0405 * c)),
                              border: Border.all(color: Color.fromRGBO(141, 131, 252, 1), width: 0.0108 * c),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dateEdit ? selectedDateString : DateFormat("dd/MM/yyyy").format(selectedDate),
                                  // selectedDate.day.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.year.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    _selectDate(context);
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    // decoration: BoxDecoration(
                                    //   color: Color.fromRGBO(141, 131, 252, 1),
                                    //   borderRadius: BorderRadius.circular(15),
                                    // ),
                                    child: Center(
                                      child: Text(
                                        "Add date",
                                        style: TextStyle(
                                          color: Color.fromRGBO(141, 131, 252, 1),
                                          fontFamily: "Poppins",
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 0.208 * c,
                            padding: EdgeInsets.only(left: 0.027 * c, right: 0.027 * c),
                            margin: EdgeInsets.only(bottom: 0.054 * c),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(0.0405 * c)),
                              border: Border.all(color: Color.fromRGBO(141, 131, 252, 1), width: 0.0108 * c),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  timeEdit
                                      ? selectedTimeString
                                      : timeSelected
                                          ? MaterialLocalizations.of(context).formatTimeOfDay(selectedTime)
                                          : "No Time Deadline",
                                  // selectedDate.day.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.year.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    _selectTime(context);
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    // decoration: BoxDecoration(
                                    //   color: Color.fromRGBO(141, 131, 252, 1),
                                    //   borderRadius: BorderRadius.circular(15),
                                    // ),
                                    child: Center(
                                      child: Text(
                                        "Add time",
                                        style: TextStyle(
                                          color: Color.fromRGBO(141, 131, 252, 1),
                                          fontFamily: "Poppins",
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
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
                                  child: !edit
                                      ? Text(
                                          "Assign Task",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 0.0468 * c,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "Edit Task",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 0.0468 * c,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            onTap: () {
                              if (edit == false) {
                                sendData(taskController.text, DateFormat("dd/MM/yyyy").format(selectedDate), MaterialLocalizations.of(context).formatTimeOfDay(selectedTime), context);
                              } else {
                                editData(taskController.text, DateFormat("dd/MM/yyyy").format(selectedDate), MaterialLocalizations.of(context).formatTimeOfDay(selectedTime), data["_id"].toString(), context);
                              }
                            },
                          ),
                          SizedBox(height: 0.0508 * c),
                          errorStatus != 0
                              ? Center(
                                  child: Container(
                                    child: Text(
                                      err,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.white,
                                        fontSize: 0.0416 * c,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  )));
  }
}
