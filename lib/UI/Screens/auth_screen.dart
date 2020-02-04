import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Services/authentication.dart';
import '../Widgets/platform_exceptoin_alert.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _devicesize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[900], Colors.blue[800], Colors.blue[700]],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: _devicesize.width * 0.07,
            top: _devicesize.width * 0.15,
            child: Container(
              width: _devicesize.width * 0.85,
              height: _devicesize.width * 0.85,
              child: Image.asset('assets/kssemlogo.png'),
            ),
          ),
          Positioned(
            top: _devicesize.width * 1,
            child: Container(
              width: _devicesize.width,
              height: _devicesize.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  topLeft: Radius.circular(40.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: buildText(
                      text: "KSSEM Connect",
                      size: 35,
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: _devicesize.height * 0.04,
                  ),
                  buildGoogleWidget(onTap: () {
                    _signInWithGoogle(context);
                  }),
                  SizedBox(
                    height: _devicesize.height * 0.04,
                  ),
                  buildText(
                    text: "Sign in with Google",
                    size: 20,
                    color: Colors.grey[800],
                  ),
                  SizedBox(
                    height: _devicesize.height * 0.1,
                  ),
                  buildText(
                      text: "desinged by Sameer",
                      size: 15,
                      color: Colors.grey[600],
                      style: FontStyle.italic),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text buildText(
      {String text,
      double size,
      Color color,
      FontStyle style,
      FontWeight fontWeight}) {
    return Text(
      text,
      style: GoogleFonts.roboto(
          textStyle: TextStyle(
              decoration: TextDecoration.none,
              fontSize: size,
              color: color,
              fontWeight: fontWeight,
              // fontFamily: fontFamily,
              fontStyle: style)),
    );
  }

  buildGoogleWidget({Function onTap}) {
    return ClipRect(
      child: Material(
        color: Colors.blue[600], // button color
        child: InkWell(
          splashColor: Colors.indigo, // inkwell color
          child: Container(
            height: 100,
            width: 100,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.asset('assets/google.gif'),
            ),
          ),
          // SizedBox(
          //   width: 100,
          //   height: 100,
          //   child: Icon(
          //     MaterialCommunityIcons.google,
          //     size: 40,
          //   ),
          // ),
          onTap: onTap,
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final userAuth = Provider.of<UserProvider>(context, listen: false);
      await userAuth.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }
}
