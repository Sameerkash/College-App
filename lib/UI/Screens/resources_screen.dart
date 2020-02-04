import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kssem/Models/class.dart';
import 'package:kssem/Services/database.dart';
import 'package:kssem/UI/Widgets/platform_exceptoin_alert.dart';
import 'package:provider/provider.dart';
// import '../Widgets/resoruces.dart';
import 'package:table_calendar/table_calendar.dart';

class ResourceScreen extends StatefulWidget {
  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  CalendarController calendarController;
  String _classRoom;
  String _batch;
  String _department;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();
  }

  @override
  void dispose() {
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Resources",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildListTileAdd(
                title: "Add a Classroom",
                onTap: () {
                  showModalBottomSheet(
                      context: context, builder: buildBottomSheet);
                }),
          ],
        ),
      ),
    );
  }

  Container buildListTileAdd({String title, Function onTap}) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.add,
            ),
            title: Text(title),
            onTap: onTap,
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          )
        ],
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

  Future<void> _submit(BuildContext context) async {
    final db = Provider.of<Database>(context, listen: false);
    if (_validateAndSaveForm()) {
      try {
        ClassRoom classRoom = ClassRoom(
          className: _classRoom,
          batch: _batch,
          department: _department,
        );

        Navigator.pop(context);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      color: Color(0xff3757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(
              20,
            ),
          ),
        ),
        padding: EdgeInsets.fromLTRB(50, 20, 50, 10),
        child: Form(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Add a Class",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                onSaved: (value) {
                  _classRoom = value;
                },
                decoration: InputDecoration(
                  hintText: "Class Name",
                  hintStyle: TextStyle(color: Colors.black),
                  focusColor: Colors.black,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                onSaved: (value) {
                  _batch = value;
                },
                decoration: InputDecoration(
                  hintText: "Year of Batch",
                  hintStyle: TextStyle(color: Colors.black),
                  focusColor: Colors.black,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                onSaved: (value) {
                  _department = value;
                },
                decoration: InputDecoration(
                  hintText: "Department",
                  hintStyle: TextStyle(color: Colors.black),
                  focusColor: Colors.black,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              RaisedButton(
                splashColor: Colors.indigo,
                color: Colors.black,
                child: Text(
                  "Create",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
