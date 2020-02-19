import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kssem/UI/Widgets/progress_bars.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  var selectedDept;
  buildDropDownButton() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('departments').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ColorLoader3(
              radius: 16,
              dotRadius: 6,
            );
          }
          // else {
          List<DropdownMenuItem> currencyItems = [];
          for (int i = 0; i < snapshot.data.documents.length; i++) {
            DocumentSnapshot snap = snapshot.data.documents[i];
            currencyItems.add(
              DropdownMenuItem(
                child: Text(
                  snap.documentID,
                  style: TextStyle(color: Colors.black),
                ),
                value: "${snap.documentID}",
              ),
            );
          }
          return DropdownButton(
              items: currencyItems,
              onChanged: (currencyValue) {
                setState(() {
                  selectedDept = currencyValue;
                });
              },
              value: selectedDept,
              isExpanded: false,
              hint: new Text(
                "Department",
                style: TextStyle(color: Colors.black),
              ));

          // }
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 12, right: 35),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(left: 10, right: 5),
              child: buildDropDownButton(),
            ),
          )
        ],
        backgroundColor: Colors.black,
        title: const Text("Notifications"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return buildNotify(context);
        },
        itemCount: 8,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }

  buildNotify(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.red[400],
        borderOnForeground: true,
        child: Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "KSSEM Office",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  splashColor: Colors.indigoAccent,
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "College will remained closed in accound of the bandh",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "23-1-2020",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        )),
      ),
    );
  }
}
