import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kssem/Models/class.dart';
import 'package:kssem/Notifiers/classroom.dart';
import 'package:kssem/Services/database.dart';
import 'package:kssem/UI/Screens/ClassRoom/class_room_screen.dart';
import 'package:kssem/UI/Widgets/platform_exceptoin_alert.dart';
import 'package:provider/provider.dart';
// import '../Widgets/resoruces.dart';
import 'package:table_calendar/table_calendar.dart';

class ResourceScreen extends StatefulWidget {
  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  CalendarController calendarController;
  TextEditingController _textEditingController;
  String _event;
  String _batch;
  String _department;

  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // ClassRoomNotifier classRoom =
    //     Provider.of<ClassRoomNotifier>(context, listen: false);
    // final db = Provider.of<Database>(context, listen: false);
    // db.getClassRoom(classRoom);
    super.initState();
    _events = {};
    _selectedEvents = [];
    _textEditingController = TextEditingController();
    calendarController = CalendarController();
  }

  @override
  void dispose() {
    calendarController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  List<String> _departments = ["CSE", "ECE", "EEE", "CIV", "ME"];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // ClassRoomNotifier classRoom = Provider.of<ClassRoomNotifier>(context);
    final db = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          // Padding(
          //   padding: EdgeInsets.only(top: 10, bottom: 12, right: 35),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20),
          //       color: Colors.white,
          //     ),
          //     // padding: EdgeInsets.only(left: 10, right: 5),
          //     // child: buildDropDownButton(() => db.getClassRoom(classRoom)),
          //   ),
          // )
        ],
        backgroundColor: Colors.black,
        title: Text(
          "Resources",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          // return db.getClassRoom(classRoom);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildListTileAdd(
                  title: "Add a Classroom",
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: buildBottomSheet,
                        isScrollControlled: true);
                  }),
              SizedBox(
                height: 20,
              ),
              TableCalendar(
                
                onDaySelected: (date, events) {
                  _selectedEvents = events;
                },
                events: _events,
                calendarController: calendarController,
                headerStyle: HeaderStyle(
                  formatButtonShowsNext: false,
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
              ),
              Divider(
                color: Colors.indigoAccent,
                thickness: 10,
                height: 50,
              ),
              ..._selectedEvents.map((event) => ListTile(
                    title: Text(event),
                  )),
              // classRoom.classRooms.length == null
              //     ? Center(
              //         child: Text("No classes"),
              //       )
              //     : Flexible(
              //         child: GridView.builder(
              //             physics: NeverScrollableScrollPhysics(),
              //             shrinkWrap: true,
              //             itemCount: classRoom.classRooms.length,
              //             gridDelegate:
              //                 SliverGridDelegateWithFixedCrossAxisCount(
              //                     crossAxisCount: 3),
              //             itemBuilder: (conext, index) {
              //               return InkWell(
              //                 onTap: () {
              //                   classRoom.currentClasRoom =
              //                       classRoom.classRooms[index];
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (context) => ClassRoomScreen()),
              //                   );
              //                 },
              //                 child: Card(
              //                   elevation: 3,
              //                   child: GridTile(
              //                     child: Center(
              //                       child: Text(
              //                           classRoom.classRooms[index].className,
              //                           style: TextStyle(
              //                               fontSize: 28,
              //                               fontWeight: FontWeight.bold)),
              //                     ),
              //                     footer: Text(
              //                         classRoom.classRooms[index].department,
              //                         style: TextStyle(
              //                             fontSize: 18,
              //                             fontWeight: FontWeight.bold)),
              //                   ),
              //                 ),
              //               );
              //             }),
              //       ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: buildBottomSheet,
              isScrollControlled: true);
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add_circle),
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
            thickness: 10,
            height: 5,
            color: Colors.indigoAccent,
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
        setState(() {
          if (_events[calendarController.selectedDay] != null) {
            _events[calendarController.selectedDay].add(_event);
          } else {
            _events[calendarController.selectedDay] = [_event];
          }
        });
        // Navigator.pop(context);
        // ClassRoom classRoom = ClassRoom(
        //   className: _classRoom,
        //   batch: _batch,
        //   department: _department,
        // );

        // db.addclassRoom(classRoom);

        // Navigator.pop(context);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  var selectedDept;
  DropdownButton buildDropDownButton(Function getClassroom) {
    return DropdownButton(
      focusColor: Colors.white,
      items: _departments
          .map(
            (val) => DropdownMenuItem(
              child: Text(
                val,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              value: val,
            ),
          )
          .toList(),
      onChanged: (value) {
        getClassroom();

        setState(() {
          selectedDept = value;
        });
      },
      value: selectedDept,
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      color: Color(0xff3757575),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Add an Event",
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
                  maxLines: 2,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enetr a valid description";
                    } else
                      return null;
                  },
                  onSaved: (value) {
                    _event = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Event Description",
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
                // SizedBox(
                //   height: 25,
                // ),
                // TextFormField(
                //   onSaved: (value) {
                //     _batch = value;
                //   },
                //   validator: (value) {
                //     if (value.isEmpty || value.length > 4) {
                //       return "Please enetr a valid year";
                //     } else
                //       return null;
                //   },
                //   decoration: InputDecoration(
                //     hintText: "Year of Batch",
                //     hintStyle: TextStyle(color: Colors.black),
                //     focusColor: Colors.black,
                //     border: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Colors.grey),
                //     ),
                //     focusedBorder: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Colors.black),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 25,
                // ),
                // TextFormField(
                //   validator: (value) {
                //     if ((value.contains("CSE") ||
                //             value.contains("ECE") ||
                //             value.contains("EEE") ||
                //             value.contains("ME") ||
                //             value.contains("CIV")) &&
                //         (value.length <= 3)) {
                //       return null;
                //     } else {
                //       return "Enter a valid Department";
                //     }
                //   },
                //   onSaved: (value) {
                //     _department = value.toUpperCase();
                //   },
                //   decoration: InputDecoration(
                //     hintText: "Department",
                //     hintStyle: TextStyle(color: Colors.black),
                //     focusColor: Colors.black,
                //     border: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Colors.grey),
                //     ),
                //     focusedBorder: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Colors.black),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 60,
                ),
                RaisedButton(
                  splashColor: Colors.indigo,
                  color: Colors.black,
                  child: Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _submit(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
