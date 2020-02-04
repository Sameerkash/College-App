import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import '../../Notifiers/theme_changer.dart';
// import 'package:provider/provider.dart';
// import 'package:kssem/Services/authentication.dart';
// import 'package:kssem/UI/Widgets/platform_alert_dialog.dart';
// import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer(this.displayName);
  final String displayName;
  @override
  Widget build(BuildContext context) {
    // final theme = Provider.of<ThemeChanger>(context, listen: false);
    return Drawer(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, left: 15, right: 10),
                    child: Text(
                      "Welcome,",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, left: 15, right: 10),
                    child: Text(
                      displayName,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, left: 15, right: 10),
                    child: Text(
                      "to KSSEM Connect",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              buildListTile(
                title: "Library",
                subtitle: "Coming Soon",
                icon: MaterialCommunityIcons.book,
              ),
              SizedBox(
                height: 5,
              ),
              buildListTile(
                  title: "Discover KSSEM",
                  subtitle: "Coming Soon",
                  icon: Octicons.globe),
              SizedBox(
                height: 300,
              ),
              // IconButton(
              //   icon: Icon(Icons.lightbulb_outline),
              //   onPressed: () {
              //     if (theme.getTheme() == ThemeData.dark()) {
              //       theme.setTheme(ThemeData.light());
              //     } else {
              //       theme.setTheme(ThemeData.dark());
              //     }
              //   },
              // ),
              buildListTile(
                  // onTap: () {
                  //   SchedulerBinding.instance.addPostFrameCallback((_) {
                  //     // close the app drawer
                  //     Navigator.of(context).pop();
                  //     _confirmSignOut(context);
                  //   });
                  // },

                  // Navigator.pop(context);
                  // Navigator.of(context).pop();

                  title: "Logout",
                  subtitle: "Sign out from the app",
                  icon: Icons.exit_to_app)
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _signOut(BuildContext context) async {
  //   try {
  //     final auth = Provider.of<UserProvider>(context, listen: false);
  //     await auth.signOut();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future<void> _confirmSignOut(BuildContext context) async {
  //   final didRequestSignOut = await PlatformAlertDialog(
  //     title: 'Logout',
  //     content: 'Are you sure that you want to logout?',
  //     cancelActionText: 'Cancel',
  //     defaultActionText: 'Logout',
  //   ).show(context);
  //   if (didRequestSignOut == true) {
  //     _signOut(context);
  //   }
  // }

  ListTile buildListTile(
      {String title, String subtitle, IconData icon, Function onTap}) {
    return ListTile(
      onTap: onTap,
      subtitle: Text(subtitle),
      title: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
      leading: Icon(
        icon,
        color: Colors.black,
      ),
    );
  }
}
