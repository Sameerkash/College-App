import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { UNINITIALIZED, AUTHENTICATED, AUTHENTICATING, UNAUTHENTICATED }

class User {
  User(
      {@required this.uid,
      @required this.photoUrl,
      @required this.displayName});
  final String uid;
  final String photoUrl;
  final String displayName;
}

class UserProvider with ChangeNotifier {
  FirebaseAuth _firebaseAuth;
  User _user;
  Status _status = Status.UNINITIALIZED;
  Status get status => _status;
  User get user => _user;
  String get uid => _user.uid;


  UserProvider.initialize() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.onAuthStateChanged.listen(_onStateChanged);
  }
  Future<void> _onStateChanged(FirebaseUser user) async {
    if (user == null) {
      _status = Status.UNAUTHENTICATED;
    } else {
      _user = _userFromFirebase(user);
      _status = Status.AUTHENTICATED;
    }
    notifyListeners();
  }

  Future<User> signInWithGoogle() async {
    _status = Status.AUTHENTICATING;
    notifyListeners();
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );

        return _userFromFirebase(authResult.user);
      } else {
        _status = Status.UNAUTHENTICATED;
        notifyListeners();

        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      _status = Status.UNAUTHENTICATED;
      notifyListeners();

      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    } else {
      return User(
        uid: user.uid,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
      );
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
    _status = Status.UNAUTHENTICATED;
    notifyListeners();

// _status = Status.UNAUTHENTICATED;
  }
}
