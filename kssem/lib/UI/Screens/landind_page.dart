
import 'package:flutter/material.dart';
import 'package:kssem/UI/Screens/check_user_exists.dart';


class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CheckUserExists(),
    );
  }
}
// get userId => userid;

// final auth = Provider.of<AuthBase>(context, listen: false);
// return StreamBuilder<User>(
//     stream: auth.onAuthStateChanged,
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.active) {
//             User user = snapshot.data;

//         // users = user;
//         if (user == null) {

// //           return AuthScreen();
//         }
//         // return MultiProvider(
//   providers: [
//     Provider<User>.value(
//       value: user,
//       child: Provider<Database>(
//         create: (_) => FirestoreDatabase(),
//       ),
//     ),
//   ],
// child:

//             return CheckUserExists();
//           } else {
//             return Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }
//         });
//   }
// }
