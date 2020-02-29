import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kssem/UI/Screens/discover_kssem_screen.dart';
import '../Screens/feed_screen.dart';
import '../Screens/notification_screen.dart';
import '../Screens/profile_screen.dart';
import '../Screens/resources_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int pageIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    pageController = PageController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
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
          // ResourceScreen(),
          ProfileScreen(),
        ],
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
