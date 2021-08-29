import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iste/core/storage/file_upload_successful.dart';
import 'package:iste/core/storage/firebase_api.dart';
import 'package:iste/database/user_database.dart';
import 'package:iste/models/user.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class UploadNewFileScreen extends StatefulWidget {
  const UploadNewFileScreen({Key? key}) : super(key: key);

  @override
  _UploadNewFileScreenState createState() => _UploadNewFileScreenState();
}

class _UploadNewFileScreenState extends State<UploadNewFileScreen> {
  final nameController = TextEditingController();
  File? file;
  UploadTask? task;
  String errorText = "";
  late List<User> user;
  bool isLoading = true;
  String type = "Permission";
  var typeData = ["Permission", "Report", "Other"];

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    user = await UserDatabase.instance.readAllUsers();
    setState(() {
      isLoading = false;
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
    });
  }

  Future sendData(String fileUrl, BuildContext context) async {
    final String url = "https://vit-iste.herokuapp.com/ff4085ad157354dc8ea67a848e7c2270b4a19282713cf3a7ecf8e0ffbb159ed1";
    final response = await http.post(Uri.parse(url), body: {
      "name": nameController.text,
      "uploadedBy": user[0].name,
      "link": fileUrl,
      "type": type,
    });
    print(response.body);
    print("file added!!!");
    Navigator.of(context).pushNamedAndRemoveUntil(FileUploadSuccessful.routeName, (route) => false);
  }

  Future uploadFile(BuildContext context) async {
    if (nameController.text == "") {
      setState(() {
        errorText = "Please enter the title";
      });
      return;
    }
    if (file == null) return;
    final fileName = basename(file!.path);
    final destination = "/files/$fileName";
    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {
      errorText = "";
    });
    if (task == null) return;
    final snapshot = await task!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("download link!!!!!!!!!!" + urlDownload);
    sendData(urlDownload, context);
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          var c = MediaQuery.of(context).size.width;
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Center(
              child: Text(
                "$percentage %",
                style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 0.04572 * c),
              ),
            );
          } else {
            return Container();
          }
        },
      );

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : "No file selected";
    var c = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(left: 0.026 * c, right: 0.026 * c),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.13 * c),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 0.026 * c),
                    child: Text(
                      "Upload a file",
                      style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 0.078 * c),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.0508 * c),
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
                  maxLines: null,
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "What are you uploading?",
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
              Center(
                child: Container(
                  child: Text(
                    "Select the type of file: ",
                    style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 150,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(hintText: "Enter the type of file", border: InputBorder.none),
                        isEmpty: type == "",
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black87,
                            value: type,
                            isDense: true,
                            onChanged: (String? newValue) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                type = newValue.toString();
                                state.didChange(newValue);
                              });
                            },
                            items: typeData.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Color.fromRGBO(141, 131, 252, 1), fontFamily: "Poppins"),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 0.0508 * c),
              GestureDetector(
                child: Center(
                  child: Container(
                    width: 0.49 * c,
                    height: 0.117 * c,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(141, 131, 252, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Icon(Icons.attachment, color: Colors.white),
                        ),
                        Text(
                          "Select file",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 0.0468 * c,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () => {selectFile()},
              ),
              SizedBox(height: 0.0108 * c),
              Center(
                child: Container(
                  child: Text(
                    fileName,
                    style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 0.04572 * c),
                  ),
                ),
              ),
              SizedBox(height: 0.108 * c),
              GestureDetector(
                child: Center(
                  child: Container(
                    width: 0.49 * c,
                    height: 0.117 * c,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(141, 131, 252, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Icon(Icons.cloud_upload, color: Colors.white),
                        ),
                        Text(
                          "Upload file",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 0.0468 * c,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () => {uploadFile(context)},
              ),
              SizedBox(height: 0.0108 * c),
              task != null ? buildUploadStatus(task!) : Container(),
              SizedBox(height: 0.0108 * c),
              Center(
                child: Text(
                  errorText,
                  style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 0.04572 * c),
                ),
              )
            ],
          ),
        ));
  }
}
