import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Notifications"),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return buildNotify(context);
          },
          itemCount: 5,
        ));
  }

  buildNotify(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        borderOnForeground: true,
        child: Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Text("VEENA RS"),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "othing to say, abstains frsc cscjfocj dkc ksdousbdothing to say, abstains frsc cscjfocj dkc ksdousbdothing to say, abstains frsc cscjfocj dkc ksdousbdothing to say, abstains frsc cscjfocj dkc ksdousbdothing to say, abstains frsc cscjfocj dkc ksdousbd",
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text("23-1-2020"),
            )
          ],
        )),
      ),
    );
  }
}
