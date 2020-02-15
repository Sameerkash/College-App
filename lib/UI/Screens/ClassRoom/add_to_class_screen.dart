import 'package:flutter/material.dart';
import 'package:kssem/Models/student.dart';
import 'package:kssem/Notifiers/classroom.dart';
import 'package:kssem/Services/database.dart';
import 'package:provider/provider.dart';

class AddToClassScreen extends StatefulWidget {
  @override
  _AddToClassScreenState createState() => _AddToClassScreenState();
}

class _AddToClassScreenState extends State<AddToClassScreen> {
  @override
  void initState() {
    ClassRoomNotifier classRoom =
        Provider.of<ClassRoomNotifier>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    db.getClassStudents(classRoom.currentClass, classRoom);
    super.initState();
  }

  List<Student> selectedStudents = [];
  // var clickBox;
  @override
  Widget build(BuildContext context) {
    ClassRoomNotifier classRoom = Provider.of<ClassRoomNotifier>(context);
    final db = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Batch ${classRoom.currentClass.batch}"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return db.getClassStudents(classRoom.currentClass, classRoom);
        },
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CheckboxListTile(
                  title: Text(
                    classRoom.classStudentsList[index].usn,
                  ),
                  subtitle: Text(classRoom.classStudentsList[index].name),
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        selectedStudents
                            .add(classRoom.classStudentsList[index]);
                      } else {
                        selectedStudents
                            .remove(classRoom.classStudentsList[index]);
                      }
                      // print(selectedStudents.length);
                    });
                  },
                  // value: classRoom.students[index].name,
                  value: selectedStudents
                      .contains(classRoom.classStudentsList[index]),
                  selected: selectedStudents
                      .contains(classRoom.classStudentsList[index]),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
              ],
            );
          },
          itemCount: classRoom.classStudentsList.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.check),
        onPressed: () {
          db.addStudentstoClass(classRoom.currentClass, selectedStudents);
        },
      ),
    );
  }
}
