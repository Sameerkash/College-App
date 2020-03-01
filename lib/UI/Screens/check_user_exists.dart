import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:kssem/Services/database.dart';
import 'package:kssem/UI/Screens/notification_screen.dart';
import '../Screens/home_screen.dart';

import '../Screens/profile_form.dart';
import '../Widgets/progress_bars.dart';
import 'package:provider/provider.dart';

class CheckUserExists extends StatefulWidget {
  static const route = 'check-user';

  @override
  _CheckUserExistsState createState() => _CheckUserExistsState();
}

class _CheckUserExistsState extends State<CheckUserExists> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  final FirebaseMessaging _fcm = FirebaseMessaging();

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    print("Title: $title, body: $body, message: $mMessage");
  }

  @override
  void initState() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");
        _setMessage(message);
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     content: ListTile(
        //       title: Text(message['notification']['title']),
        //       subtitle: Text(message['notification']['body']),
        //     ),
        //     actions: <Widget>[
        //       FlatButton(
        //         child: Text('Ok'),
        //         onPressed: () => Navigator.of(context).pop(),
        //       ),
        //     ],
        //   ),
        // );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _setMessage(message);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      },
      onResume: (Map<String, dynamic> message) async {
        // print("onResume: $message");

        _setMessage(message);
      },
    );

    _saveDeviceToken(context);

    super.initState();
  }

  /// Get the token, save it to the database for current user
  _saveDeviceToken(BuildContext context) async {
    final db = Provider.of<Database>(context, listen: false);
    String fcmToken = await _fcm.getToken();
    // print(fcmToken);

    if (fcmToken != null) {
      db.setFCMtoken(fcmToken);
    }
  }

  checkUser(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return _memoizer.runOnce(() async {
      final res = await db.getFaculty();
      return res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this.checkUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
              ),
              body: Center(
                child: ColorLoader3(
                  radius: 16,
                  dotRadius: 6,
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return ProfileForm();
          } else {
            return HomeScreen();
          }
        });
  }
}
