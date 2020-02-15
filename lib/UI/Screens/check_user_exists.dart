import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:kssem/Services/database.dart';
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

  checkUser(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return _memoizer.runOnce(() async {
      final res = await db.getFaculty();
      return res;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final db = Provider.of<Database>(context,listen: false);
    // bool isExists = true;

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
