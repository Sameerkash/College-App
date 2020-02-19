// import 'package:flutter/material.dart';
// import 'package:kssem/Notifiers/classroom.dart';
// import 'package:kssem/Services/database.dart';
// import 'package:provider/provider.dart';

// class ClassStudentsScreen extends StatefulWidget {
//   ClassStudentsScreen({this.classRoom});
//   final ClassRoomNotifier classRoom;

//   @override
//   _ClassStudentsScreenState createState() => _ClassStudentsScreenState();
// }

// class _ClassStudentsScreenState extends State<ClassStudentsScreen> {
//   @override
//   void initState() {
//     ClassRoomNotifier classRoom =
//         Provider.of<ClassRoomNotifier>(context, listen: false);
//     final db = Provider.of<Database>(context, listen: false);
//     db.getSelectedClassStudents(classRoom);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ClassRoomNotifier classRoom = Provider.of<ClassRoomNotifier>(context);
//     final db = Provider.of<Database>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Class ${widget.classRoom.currentClass.className}"),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () {
//           return db.getSelectedClassStudents(classRoom);
//         },
//         child: ListView.builder(
//           physics: AlwaysScrollableScrollPhysics(),
//           itemBuilder: (context, index) {
//             return buildListTile(classRoom, index);
//           },
//           itemCount: classRoom.getSelectedStudents.length,
//         ),
//       ),
//     );
//   }

//   Container buildListTile(ClassRoomNotifier classRoom, int index) {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           ListTile(
//             title: Text(
//               classRoom.getSelectedStudents[index].usn,
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(
//               classRoom.getSelectedStudents[index].name,
//               style: TextStyle(fontWeight: FontWeight.w900),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
