import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kssem/Models/student.dart';
import 'package:kssem/Services/authentication.dart';
import 'package:kssem/Services/database.dart';
import 'package:kssem/UI/Widgets/platform_alert_dialog.dart';
// import 'package:kssem/UI/Screens/home_screen.dart';
import 'package:kssem/UI/Widgets/platform_exceptoin_alert.dart';
import 'package:provider/provider.dart';

class ProfileForm extends StatefulWidget {
  static const route = '/profile-form';

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _usn;
  String _email;
  String _phone;
  String _branch;
  String _degree;
  String _batch;
  // String _classKey;

  List<String> _deptNames = ["CSE", "CIV", "EEE", "ECE", "MECH"];

  List<String> _degrees = ["B.E", "M.B.A"];

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<UserProvider>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Are you sure you want to cancel?',
      content: 'You will be logged out of the app.',
      cancelActionText: 'Cancel',
      defaultActionText: 'OK',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.person),
        backgroundColor: Colors.black,
        title: Text(
          "Complete Your Profile",
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          Icon(Icons.cancel),
          FlatButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _confirmSignOut(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.indigo[400],
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    buildTextFormField("Full Name (ex: Sam Kash)", (value) {
                      if (value.length > 6) {
                        return null;
                      } else {
                        return "Enter Full Name ";
                      }
                    }, (value) => _name = value, Icons.person),
                    buildTextFormField("USN (ex: 1KG17CSXXX)", (value) {
                      if (value.startsWith("1KG")) {
                        return null;
                      } else {
                        return "Enter a valid USN,Please type as example";
                      }
                    }, (value) => _usn = value.toUpperCase(),
                        Icons.confirmation_number),
                    buildTextFormField("Phone", (value) {
                      if (value.length == 10) {
                        return null;
                      } else {
                        return "Enter valid number";
                      }
                    }, (value) => _phone = value, Icons.phone),
                    buildTextFormField("Email", (value) {
                      if (value.contains("@")) {
                        return null;
                      } else {
                        return "Enter valid email ";
                      }
                    }, (value) => _email = value, Icons.mail),
                    // buildTextFormField("Branch (ex: CSE)", (value) {
                    //   // Pattern pattern = r"/[CSE\,ECE\,EEE\,ME\,CIV]/";
                    //   // RegExp regex = new RegExp(pattern);

                    //   if ((value.contains("CSE") ||
                    //           value.contains("ECE") ||
                    //           value.contains("EEE") ||
                    //           value.contains("ME") ||
                    //           value.contains("CIV")) &&
                    //       (value.length <= 3)) {
                    //     return null;
                    //   } else {
                    //     return "Enter a valid Branch,Please type as example";
                    //   }
                    // }, (value) => _branch = value.toUpperCase(),
                    // MaterialCommunityIcons.alphabetical),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 18, top: 18),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        padding: EdgeInsets.all(8),
                        // color: Colors.white,
                        height: 60,
                        child: Row(
                          children: <Widget>[
                            Icon(MaterialCommunityIcons.google_classroom),
                            SizedBox(
                              width: 30,
                            ),
                            DropdownButton(
                              items: _deptNames
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _branch = value;
                                  print(_branch);
                                });
                              },
                              value: _branch,
                              isExpanded: false,
                              hint: Text(
                                "Department",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    buildTextFormField("Batch (ex:2017)", (value) {
                      if (value.length == 4) {
                        return null;
                      } else {
                        return "Enter a valid Batch Year,Please type as example";
                      }
                    }, (value) => _batch = value, Icons.date_range),

                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 18, top: 18),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        padding: EdgeInsets.all(8),
                        // color: Colors.white,
                        height: 60,
                        child: Row(
                          children: <Widget>[
                            Icon(MaterialCommunityIcons.certificate),
                            SizedBox(
                              width: 30,
                            ),
                            DropdownButton(
                              items: _degrees
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _degree = value;
                                  print(_degree);
                                });
                              },
                              value: _degree,
                              isExpanded: false,
                              hint: Text(
                                "Degree",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // buildTextFormField("Degree (ex: B.E)", (value) {
                    //   if (value.contains("B.E")) {
                    //     return null;
                    //   } else {
                    //     return "Enter a valid Degree,Please type as example";
                    //   }
                    // }, (value) => _degree = value.toUpperCase(),
                    //     MaterialCommunityIcons.google_classroom),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              buildNextButton(_submitFuture)
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTextFormField(
      String hintText, Function validate, Function onSaved, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: ListTile(
        //  leading: Icon(icon,color: Colors.white,),
        title: TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            errorStyle: TextStyle(
              color: Colors.white,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            ),
            hoverColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  style: BorderStyle.solid, color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            ),
          ),
          validator: validate,
          onSaved: onSaved,
        ),
      ),
    );
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      return true;
    }
    return false;
  }

  buildNextButton(Function onTap) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.indigo[300], // button color
        child: InkWell(
          splashColor: Colors.indigo[900], // inkwell color
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: Icon(
              MaterialCommunityIcons.chevron_double_right,
              size: 40,
              color: Colors.white,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  _submitFuture() {
    _submit(this.context);
    Timer(Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, 'check-user');
    });
  }

  Future<void> _submit(BuildContext context) async {
    final db = Provider.of<Database>(context, listen: false);
    if (_validateAndSaveForm()) {
      if (_branch == null && _degree == null) {
        PlatformAlertDialog(
                title: "Error",
                content: "PLease fill all the values",
                defaultActionText: "OK")
            .show(context);
        return null;
      } else {
        try {
          Student student = Student(
            uid: db.userId,
            usn: _usn,
            name: _name,
            displayName: db.displayName,
            branch: _branch,
            email: _email,
            phone: _phone,
            photoUrl: db.photoUrl,
            degree: _degree,
            batch: _batch,
            classKey: _branch + _batch,
          );
          await db.setStudent(student);
        } on PlatformException catch (e) {
          PlatformExceptionAlertDialog(
            title: 'Operation failed',
            exception: e,
          ).show(context);
        }
      }
    }
  }
}
