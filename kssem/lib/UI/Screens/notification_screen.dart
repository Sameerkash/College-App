import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kssem/Models/notificaion.dart';
import 'package:kssem/Notifiers/profile_notifier.dart';
import 'package:kssem/UI/Screens/image_preview_screen.dart';
import 'package:kssem/UI/Widgets/progress_bars.dart';
import 'package:kssem/Utilities/size_config.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();

    // ProfileNotifier student =
    //     Provider.of<ProfileNotifier>(context, listen: false);
    // final db = Provider.of<Database>(context, listen: false);
    // db.getStudentProfile(student);
    // db.getStudent();
  }

  // var dept;
  // buildDropDownButton() {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: Firestore.instance.collection('departments').snapshots(),
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return ColorLoader3(
  //             radius: 16,
  //             dotRadius: 6,
  //           );
  //         }
  //         // else {
  //         List<DropdownMenuItem> currencyItems = [];
  //         for (int i = 0; i < snapshot.data.documents.length; i++) {
  //           DocumentSnapshot snap = snapshot.data.documents[i];

  //           currencyItems.add(
  //             DropdownMenuItem(
  //               child: Text(
  //                 snap.documentID,
  //                 style: TextStyle(color: Colors.black),
  //               ),
  //               value: "${snap.documentID}",
  //             ),
  //           );
  //         }
  //         return DropdownButton(
  //             items: currencyItems,
  //             onChanged: (currencyValue) {
  //               setState(() {
  //                 selectedDept = currencyValue;
  //                 print(selectedDept);
  //               });
  //             },
  //             value: selectedDept,
  //             isExpanded: false,
  //             hint: new Text(
  //               "Department",
  //               style: TextStyle(color: Colors.black),
  //             ));

  //         // }
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    // NotificationNotifier notificationNotifier =
    // Provider.of<NotificationNotifier>(context);
    // final db = Provider.of<Database>(context);
    ProfileNotifier student =
        Provider.of<ProfileNotifier>(context, listen: false);
    var format = DateFormat('dd MMM yy | h:mm a');
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        // actions: <Widget>[
        //   Padding(
        //     padding: EdgeInsets.only(top: 10, bottom: 12, right: 35),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20),
        //         color: Colors.white,
        //       ),
        //       padding: EdgeInsets.only(left: 10, right: 5),
        //       child: buildDropDownButton(),
        //     ),
        //   )
        // ],
        backgroundColor: Theme.of(context).appBarTheme.color,
        title: const Text("Notifications"),
      ),
      body:
          //  selectedDept == null
          //     ? Center(
          //         child: Container(
          //           padding: EdgeInsets.all(20),
          //           child: Text(
          //             "Please select a Department to View or Send a Notification",
          //             style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          //           ),
          //         ),
          //       )
          Stack(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('departments')
                  .document('${student.student.branch}')
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
                          style: TextStyle(color: Colors.black, fontSize: 30),
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
                                .format(notifications[index].createdAt.toDate())
                                .toString(),
                          );
                        },
                        itemCount: notifications.length,
                      );
              }),
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
      padding: const EdgeInsets.all(2.0),
      child: Card(
        color: Theme.of(context).iconTheme.color,
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
                // IconButton(
                //     splashColor: Colors.indigoAccent,
                //     icon: Icon(
                //       Icons.delete_forever,
                //       color: Colors.white,
                //     ),
                //     onPressed: onDelete)
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
                : Hero(
                    tag: "$imageUrl",
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ImagePreview(imageUrl: imageUrl)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: SizeConfig.blockSizeVertical * 20,
                              maxWidth: SizeConfig.screenWidth),
                          child:
                              // Stack(children: [
                              Container(
                            // color: Colors.grey[200],
                            foregroundDecoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            decoration: BoxDecoration(
                                boxShadow: [BoxShadow(color: Colors.white)],
                                borderRadius: BorderRadius.circular(40),
                                // border: Border(: BorderSide(color: Colors.black)),
                                image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover)),
                            // child: Image.network(
                            //   imageUrl,
                            //   fit: BoxFit.cover,
                          ),
                          //   Align(
                          //     alignment: Alignment.bottomCenter,
                          //     child:
                          //         Material(child: Text("Tap to Preview Image",style: TextStyle(fontSize: 8),)),
                          //   ),
                          // ]),
                        ),
                      ),
                    ),
                  ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                // "23-1-2020",
                createAt,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.textMultiplier * 1.3),
              ),
            )
          ],
        )),
      ),
    );
  }
}
