import 'package:flutter/material.dart';

class BroadcastTiles extends StatelessWidget {
  Map data;
  BroadcastTiles(this.data);

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    return Container(
      width: 1.04 * c,
      margin: EdgeInsets.only(bottom: 0.0508 * c),
      padding: EdgeInsets.all(0.0508 * c),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "By: ",
                style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontWeight: FontWeight.bold, fontSize: 0.0312 * c),
              ),
              Text(
                data["name"],
                style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontWeight: FontWeight.bold, fontSize: 0.0312 * c),
              ),
              Expanded(
                child: Text(
                  data["dateTime"],
                  textAlign: TextAlign.right,
                  style: TextStyle(fontFamily: "Poppins", color: Colors.white, fontWeight: FontWeight.bold, fontSize: 0.0312 * c),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0.026 * c,
          ),
          Text(
            data["description"],
            style: TextStyle(fontFamily: "Poppins", color: Colors.white),
          ),
        ],
      ),
    );
  }
}
