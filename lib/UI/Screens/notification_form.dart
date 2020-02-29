// import 'package:flutter/material.dart';
// import 'package:kssem/Services/database.dart';
// import 'package:provider/provider.dart';
// import '../../Models/notification.dart';

// class NotificationForm extends StatefulWidget {
//   final String selectedDept;
//   final bool isCollegeNotification;
//   final bool isDepartmentnotification;

//   NotificationForm(
//       {this.selectedDept,
//       this.isCollegeNotification,
//       this.isDepartmentnotification});

//   @override
//   _NotificationFormState createState() => _NotificationFormState();
// }

// class _NotificationFormState extends State<NotificationForm> {
//   final _formKey = GlobalKey<FormState>();
//   String _content;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Send Notification"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.all(10),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: <Widget>[
//                     // Container(
//                     //   padding: EdgeInsets.all(5),
//                     //   child: TextFormField(
//                     //     decoration: InputDecoration(
//                     //       errorBorder: OutlineInputBorder(
//                     //         borderSide: BorderSide(
//                     //             style: BorderStyle.solid,
//                     //             color: Colors.red,
//                     //             width: 2),
//                     //       ),
//                     //       hintText: "Title",
//                     //       hintStyle: TextStyle(
//                     //         fontWeight: FontWeight.w800,
//                     //       ),
//                     //     ),
//                     //     validator: (value) {
//                     //       if (value.length > 25) {
//                     //         return "Title should be less than 25 characters";
//                     //       } else if (value.isEmpty) {
//                     //         return "Title cannot be empty";
//                     //       } else
//                     //         return null;
//                     //     },
//                     //     onSaved: (value) {
//                     //       // _title = value;
//                     //     },
//                     //     maxLines: 2,
//                     //   ),
//                     // ),

//                     TextFormField(
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: "Notification content",
//                         hintStyle: TextStyle(fontSize: 25),
//                       ),
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return "Content canot be empty";
//                         } else
//                           return null;
//                       },
//                       keyboardType: TextInputType.multiline,
//                       maxLines: null,
//                       onSaved: (value) {
//                         // _content = value;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   bool _validateAndSaveForm() {
//     final form = _formKey.currentState;
//     if (form.validate()) {
//       form.save();

//       return true;
//     }
//     return false;
//   }

//   Future<void> _submit(BuildContext context) async {
//     final db = Provider.of<Database>(context, listen: false);
//     if (_validateAndSaveForm()) {
//       try {
//         // String dateTime = DateTime.now().toIso8601String();
//         // Timestamp timeStamp = Timestamp.now();

//         if (widget.isDepartmentnotification == true &&
//             widget.isCollegeNotification == false) {
//           Notifications notifiy = Notifications(
//             uid: db.userId,
//             facultyName: db.displayName,
//             content: _content,
//           );

//           // print(widget.selectedDept);

//           await db.setNotificationImage(
//               notification: notifiy,
//               currentdepartment: widget.selectedDept,
//               isCollegeNotify: widget.isCollegeNotification,
//               isDetNotify: widget.isDepartmentnotification);
//         } else if (widget.isDepartmentnotification == false &&
//             widget.isCollegeNotification == true) {
//           Notifications notifiy = Notifications(
//             uid: db.userId,
//             facultyName: db.displayName,
//             content: _content,
//           );
//           await db.setNotificationImage(
//               notification: notifiy,
//               currentdepartment: widget.selectedDept,
//               isCollegeNotify: widget.isCollegeNotification,
//               isDetNotify: widget.isDepartmentnotification);
//         }
//       } catch (e) {
//         throw "$e";
//       }
//     }
//   }
// }
