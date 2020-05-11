import 'package:flutter/material.dart';

// buildNotify() {
//   return Container(
//     child: Column(
//       children: <Widget>[
//         buildHeaderNotify(),
//         buildContent(),
//       ],
//     ),
//   );
// }

Flexible buildContent() {
  return Flexible(
    fit: FlexFit.loose,
    child: Padding(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Column(
        children: <Widget>[
          Text("JAVA Class"),
          Text(
            "Come to 3rd floor class 4th ",
          ),
        ],
      ),
    ),
  );
}

buildHeaderNotify() {
  return Container(
    child: Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.white,
        ),
        Column(
          children: <Widget>[
            Text("Veena"),
            Text(
              "HoD,CSE",
            )
          ],
        )
      ],
    ),
  );
}

buildFooter() {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.black),
      ),
    ),
    child: Text("1:45,25-1-20"),
  );
}
