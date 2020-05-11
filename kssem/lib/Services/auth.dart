// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class User {
//   User(
//       {@required this.uid,
//       @required this.photoUrl,
//       @required this.displayName});
//   final String uid;
//   final String photoUrl;
//   final String displayName;
// }

// abstract class AuthBase {
//   Stream<User> get onAuthStateChanged;
//   Future<User> currentUser();
//   Future<User> signInWithGoogle();
//   Future<void> signOut();
  
// }

// class Auth extends AuthBase {
//   final _firebaseAuth = FirebaseAuth.instance;


//   User _userFromFirebase(FirebaseUser user) {
//     if (user == null) {
//       return null;
//     } else {
//       return User(
//         uid: user.uid,
//         displayName: user.displayName,
//         photoUrl: user.photoUrl,
//       );
//     }
//   }

//   Stream<User> get onAuthStateChanged {
//     return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
//   }

//   Future<User> currentUser() async {
//     final user = await _firebaseAuth.currentUser();

//     return _userFromFirebase(user);
//   }


//   @override
//   Future<User> signInWithGoogle() async {
//     final googleSignIn = GoogleSignIn();
//     final googleAccount = await googleSignIn.signIn();
//     if (googleAccount != null) {
//       final googleAuth = await googleAccount.authentication;
//       if (googleAuth.accessToken != null && googleAuth.idToken != null) {
//         final authResult = await _firebaseAuth.signInWithCredential(
//           GoogleAuthProvider.getCredential(
//             idToken: googleAuth.idToken,
//             accessToken: googleAuth.accessToken,
//           ),
//         );

//         return _userFromFirebase(authResult.user);
//       } else {
//         throw PlatformException(
//           code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
//           message: 'Missing Google Auth Token',
//         );
//       }
//     } else {
//       throw PlatformException(
//         code: 'ERROR_ABORTED_BY_USER',
//         message: 'Sign in aborted by user',
//       );
//     }
//   }

//   Future<void> signOut() async {
//     final googleSignIn = GoogleSignIn();
//     await googleSignIn.signOut();
//     await _firebaseAuth.signOut(); // _status = Status.UNAUTHENTICATED;
//   }
// }
