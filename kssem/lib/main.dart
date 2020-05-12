import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kssem/Notifiers/profile_notifier.dart';
import 'package:kssem/Notifiers/search_notifier.dart';
import 'package:kssem/Notifiers/theme_changer.dart';
import 'package:kssem/Notifiers/timeline_notifier.dart';
import 'package:kssem/Services/authentication.dart';
import 'package:kssem/Services/database.dart';
import 'package:kssem/UI/Screens/auth_screen.dart';
import 'package:kssem/UI/Screens/check_user_exists.dart';
import 'package:kssem/UI/Screens/home_screen.dart';
import 'package:kssem/UI/Screens/profile_form.dart';
import 'package:kssem/Utilities/size_config.dart';
import 'package:provider/provider.dart';
import './Utilities/theme_config.dart';
import 'UI/Screens/landind_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<UserProvider>(
        create: (_) => UserProvider.initialize(),
      ),
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
      ChangeNotifierProvider<ThemeChanger>(
        create: (_) => ThemeChanger(
            //  AppTheme.lightTheme,
            ),
      )
    ], child: MatApp());
  }
}

class MatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: theme.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        home: Scaffold(
          body: ScreenController(),
        ),
        routes: {
          CheckUserExists.route: (ctx) => CheckUserExists(),
          HomeScreen.route: (ctx) => HomeScreen(),
          ProfileForm.route: (ctx) => ProfileForm(),
          // AcademicScreen.route: (ctx) => AcademicScreen(),
        });
  }
}

class ScreenController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
