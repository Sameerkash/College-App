import 'package:async/async.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kssem/Services/database.dart';
import 'package:kssem/UI/Screens/home_screen.dart';
import 'package:kssem/UI/Screens/notification_screen.dart';
import 'package:kssem/UI/Screens/profile_form.dart';
import 'package:kssem/UI/Widgets/progress_bars.dart';
import 'package:kssem/UI/Widgets/shimmer_widgets.dart';
import 'package:provider/provider.dart';

class CheckUserExists extends StatefulWidget {
  static const route = 'check-user';

  @override
  _CheckUserExistsState createState() => _CheckUserExistsState();
}

class _CheckUserExistsState extends State<CheckUserExists> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
  }

  checkUser(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return _memoizer.runOnce(() async {
      final res = await db.getStudent();
      return res;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final db = Provider.of<Database>(context,listen: false);
    // bool isExists = true;

    return FutureBuilder(
        future: checkUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).appBarTheme.color,
              ),
              body: TimlineShimmer(),
              bottomNavigationBar: CurvedNavigationBar(
                // key: _bottomNavigationKey,
                // index: pageIndex,
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
                color: Theme.of(context).colorScheme.primary,
                buttonBackgroundColor: Theme.of(context).iconTheme.color,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 500),
                // onTap: onTap
              ),
            );
          }
          if (!snapshot.hasData) {
            // isExists = false;
            return ProfileForm();
          } else {
            return HomeScreen();
            // }

            // return isExists ? HomeScreen() : Scaffold(body: ProfileForm());
            // Navigator.pushNamed(context, '/profile-form');
            // },
            // );
          }
        });
  }
}
