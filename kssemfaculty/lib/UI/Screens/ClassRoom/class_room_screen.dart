// import 'package:flutter/material.dart';
// import 'package:kssem/Notifiers/classroom.dart';
// import 'package:kssem/UI/Screens/ClassRoom/add_to_class_screen.dart';
// import 'package:kssem/UI/Screens/ClassRoom/class_students_screen.dart';
// import 'package:provider/provider.dart';

// class ClassRoomScreen extends StatefulWidget {
//   @override
//   _ClassRoomScreenState createState() => _ClassRoomScreenState();
// }

// class _ClassRoomScreenState extends State<ClassRoomScreen> {
//   @override
//   Widget build(BuildContext context) {
//     ClassRoomNotifier classRoom = Provider.of<ClassRoomNotifier>(context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           "Class  ${classRoom.currentClass.className}",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: SingleChildScrollView(
//         physics: AlwaysScrollableScrollPhysics(),
//         child: Column(
//           children: <Widget>[
//             buildListTileAdd(
//                 icon: Icons.add,
//                 title: "Add Students",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AddToClassScreen()),
//                   );
//                 }),
//             buildListTileAdd(
//                 icon: Icons.add,
//                 title: "Add Notes and Assignments",
//                 onTap: () {
//                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
//                 }),
//             buildListTileAdd(
//                 icon: Icons.add,
//                 title: "Add class Time Table",
//                 onTap: () {
//                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
//                 }),
//             Divider(
//               height: 3,
//               color: Colors.indigoAccent,
//               thickness: 5,
//             ),
//             buildListTileAdd(
//                 title: "View Students of this class",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ClassStudentsScreen(
//                         classRoom: classRoom,
//                       ),
//                     ),
//                   );
//                 },
//                 icon: Icons.arrow_forward_ios),
//             Divider(
//               height: 50,
//             ),
//             Container(
//               color: Colors.grey,
//               height: 300,
//               width: 400,
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         child: Icon(Icons.notifications),
//         onPressed: () {},
//       ),
//     );
//   }
// }

// Container buildListTileAdd({String title, Function onTap, IconData icon}) {
//   return Container(
//     child: Column(
//       children: <Widget>[
//         ListTile(
//           leading: Icon(icon),
//           title: Text(title),
//           onTap: onTap,
//         ),
//         Divider(
//           height: 2,
//           color: Colors.grey,
//         )
//       ],
//     ),
//   );
// }
