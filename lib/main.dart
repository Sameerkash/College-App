import 'package:flutter/material.dart';
import 'package:kssem/Notifiers/classroom.dart';
import 'package:kssem/Notifiers/profile_notifier.dart';
import 'package:kssem/Notifiers/search_notifier.dart';
// import 'package:kssem/Notifiers/theme_changer.dart';
import 'package:kssem/Notifiers/timeline_notifier.dart';
import 'package:kssem/Services/authentication.dart';
import 'package:kssem/Services/database.dart';
import 'package:kssem/UI/Screens/academic_screen.dart';
import 'package:kssem/UI/Screens/auth_screen.dart';
import 'package:kssem/UI/Screens/check_user_exists.dart';
import 'package:kssem/UI/Screens/home_screen.dart';
import 'package:kssem/UI/Screens/profile_form.dart';
import 'package:provider/provider.dart';

import 'UI/Screens/landind_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider<AuthBase>(
        //   create: (context) => Auth(),
        // ),
        // Provider<LandingPage>(
        //   create: (context) => LandingPage(),
        // ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider.initialize(),
        ),
        // Provider<Database>(create: (_) => FirestoreDatabase()),
        ProxyProvider<UserProvider, Database>(
          update: (_, auth, __) =>
              FirestoreDatabase(uid: auth.uid, user: auth.user),
        ),
        ChangeNotifierProvider<TimelineNotifer>(
          create: (context) => TimelineNotifer(),
        ),
        ChangeNotifierProvider<ProfileNotifier>(
          create: (context) => ProfileNotifier(),
        ),
        ChangeNotifierProvider<SearchNotifier>(
          create: (context) => SearchNotifier(),
        ),
        // ChangeNotifierProvider<ClassRoomNotifier>(
        //   create: (context) => ClassRoomNotifier(),
        // )
        // ChangeNotifierProvider<ThemeChanger>(
        //   create: (_) => ThemeChanger(
        //     ThemeData.dark(),
        //   ),
        // )
      ],
      child: MatApp(),
    );
  }
}

class MatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.black),
        // theme: Provider.of<ThemeChanger>(context).getTheme(),
        home: Scaffold(
          body: ScreenController(),
        ),
        routes: {
          CheckUserExists.route: (ctx) => CheckUserExists(),
          HomeScreen.route: (ctx) => HomeScreen(),
          ProfileForm.route: (ctx) => ProfileForm(),
          AcademicScreen.route: (ctx) => AcademicScreen(),
        });
  }
}

class ScreenController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch (user.status) {
      case Status.UNINITIALIZED:
        return CircularProgressIndicator();
      case Status.UNAUTHENTICATED:
      case Status.AUTHENTICATING:
        return AuthScreen();
      case Status.AUTHENTICATED:
        return LandingPage();
      default:
        return AuthScreen();
    }
  }
}
