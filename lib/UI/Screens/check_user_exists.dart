import 'package:flutter/material.dart';
import 'package:kssem/Services/database.dart';
import '../Screens/home_screen.dart';
import '../Screens/profile_form.dart';
import '../Widgets/progress_bars.dart';
import 'package:provider/provider.dart';

class CheckUserExists extends StatelessWidget {
  static const route = 'check-user';

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context);
    // bool isExists = true;

    return FutureBuilder(
      future: db.getFaculty(),
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
        }

        // return isExists ? HomeScreen() : Scaffold(body: ProfileForm());
        // Navigator.pushNamed(context, '/profile-form');
      },
    );
  }
}
