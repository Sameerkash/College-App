import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kssem/Models/notification.dart';
import 'package:kssem/Services/database.dart';
// import 'package:kssem/Notifiers/notification_notifier.dart';
import 'package:kssem/UI/Screens/timeline_form.dart';
import 'package:kssem/UI/Widgets/platform_alert_dialog.dart';
import 'package:kssem/UI/Widgets/progress_bars.dart';
import 'package:kssem/Utilities/size_config.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  String selectedDept;
  Notifications currentNotification;
  // var dept;
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
                  print(selectedDept);
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
    // NotificationNotifier notificationNotifier =
    // Provider.of<NotificationNotifier>(context);
    final db = Provider.of<Database>(context);
    var format = DateFormat('dd MMM yy | h:mm a');
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
      body: selectedDept == null
          ? Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Please select a Department to View or Send a Notification",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : Stack(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('departments')
                        .document('$selectedDept')
                        .collection('notifications')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      // print(selectedDept);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: ColorLoader3(
                            radius: 16,
                            dotRadius: 6,
                          ),
                        );
                      }
                      List<Notifications> notifications = [];
                      snapshot.data.documents.forEach((doc) {
                        Notifications notify = Notifications.fromMap(doc.data);
                        notifications.add(notify);
                        // print(notifications.length);
                      });

                      // notificationNotifier.notificationList = notifications
                      print(snapshot.data.documents.length);
                      return snapshot.data.documents.length == 0
                          ? Center(
                              child: Text(
                                "No Notifications to Show",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 30),
                              ),
                            )
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return buildNotify(
                                  context,
                                  facultyName: notifications[index].facultyName,
                                  imageUrl: notifications[index].imageUrl,
                                  content: notifications[index].content,
                                  createAt: format
                                      .format(notifications[index]
                                          .createdAt
                                          .toDate())
                                      .toString(),
                                  onDelete: () async {
                                    final didRequestSignOut =
                                        await PlatformAlertDialog(
                                      title:
                                          'Are you sure you want to delete this?',
                                      content: 'This action cannot be undone',
                                      cancelActionText: 'Cancel',
                                      defaultActionText: 'Delete',
                                    ).show(context);
                                    if (didRequestSignOut == true) {
                                      currentNotification =
                                          notifications[index];
                                      db.deleteNotification(
                                          currentNotification, selectedDept);
                                    }
                                  },
                                );
                              },
                              itemCount: notifications.length,
                            );
                    }),
                Positioned(
                  top: SizeConfig.blockSizeVertical * 68,
                  left: SizeConfig.blockSizeHorizontal * 78,
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.notifications_active,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    heroTag: "departmentwide",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TimelineForm(
                                    isDepartmentnotification: true,
                                    isCollegeNotification: false,
                                    selectedDept: selectedDept,
                                  )));
                    },
                  ),
                ),
                Positioned(
                   top: SizeConfig.blockSizeVertical * 58,
                  left: SizeConfig.blockSizeHorizontal * 78,
                  child: FloatingActionButton(
                    child: Icon(Icons.notifications),
                    backgroundColor: Colors.black,
                    heroTag: "collegewide",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TimelineForm(
                                    isDepartmentnotification: false,
                                    isCollegeNotification: true,
                                  )));
                    },
                  ),
                ),
              ],
            ),
      // floatingActionButton:
    );
  }

  buildNotify(BuildContext context,
      {String facultyName,
      String content,
      String imageUrl,
      String createAt,
      Function onDelete}) {
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
                    facultyName,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                    splashColor: Colors.indigoAccent,
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                    onPressed: onDelete)
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                // "College will remained closed in accound of the bandh",
                content,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            imageUrl == null
                ? Container(
                    height: 0,
                  )
                : Container(
                    color: Colors.grey[200],
                    height: 500,
                    width: 400,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                // "23-1-2020",
                createAt,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        )),
      ),
    );
  }
}
