import 'package:flutter/material.dart';

class TaskTiles extends StatelessWidget {
  Map data;

  TaskTiles(this.data);

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/task_details_screen", arguments: {"data": data}),
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
                  data["task"],
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
                      "Deadline: " + data["deadline"],
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
    );
  }
}
