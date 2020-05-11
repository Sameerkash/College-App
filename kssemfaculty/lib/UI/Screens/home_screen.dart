import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kssem/Services/database.dart';
// import 'package:kssem/UI/Screens/profile_form.dart';
import 'package:provider/provider.dart';
import '../Screens/feed_screen.dart';
import '../Screens/notification_screen.dart';
import '../Screens/profile_screen.dart';
import 'discover_kssem_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int pageIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

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
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");
        _setMessage(message);
        Scaffold.of(_scaffoldContext).showSnackBar(snackBar);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        // print("onResume: $message");

        _setMessage(message);
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) =>
      },
    );
    _saveDeviceToken(context);

    pageController = PageController();
  }

  _saveDeviceToken(BuildContext context) async {
    final db = Provider.of<Database>(context, listen: false);
    String fcmToken = await _fcm.getToken();
    // print(fcmToken);

    if (fcmToken != null) {
      db.setFCMtoken(fcmToken);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    // setState(() {
    //   this.pageIndex = pageIndex;
    // });
    pageController.jumpToPage(pageIndex);
  }

  BuildContext _scaffoldContext;

  final snackBar = SnackBar(
      duration: Duration(seconds: 4),
      content: Text(
        "New Notification!",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;
          return

              // IndexedStack(
              //   index: pageIndex,
              //   children: <Widget>[
              //     FeedScreen(),
              //     NotificationScreen(),
              //     ResourceScreen(),
              //     ProfileScreen(),
              //   ],
              // ),
              PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: onPageChanged,
            children: <Widget>[
              FeedScreen(),
              NotificationScreen(),
              DiscoverKssemScreen(),
              // ProfileForm(),
              // ResourceScreen(),
              ProfileScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: pageIndex,
          height: 65.0,
          items: <Widget>[
            Icon(
              MaterialCommunityIcons.home,
              size: 27,
              color: Colors.white,
            ),
            Icon(Entypo.notification, size: 27, color: Colors.white),
            // Icon(FontAwesome.book, size: 27, color: Colors.white),
            Icon(Entypo.folder, size: 27, color: Colors.white),
            Icon(Icons.perm_identity, size: 27, color: Colors.white),
          ],
          color: Colors.black,
          buttonBackgroundColor: Colors.black,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 500),
          onTap: onTap),
    );
  }
}
