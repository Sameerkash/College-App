// import 'package:flutter/material.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';

// Widget buildChip(String label) {
//   return ActionChip(
//     //build action chip to show the assignments
//     padding: EdgeInsets.all(5),
//     onPressed: () {},
//     label: Text(label),
//     avatar: Icon(MaterialCommunityIcons.file_outline),
//     labelPadding: EdgeInsets.all(5),
//   );
// }

// buildResoruces(BuildContext context, CalendarController calenderController) {
//   final _deviceSize = MediaQuery.of(context);

//   return SingleChildScrollView(
//     child: Column(
//       children: <Widget>[
//         buildAcademicListTile(_deviceSize, context),
//         buildTimetable(),
//         SizedBox(
//           height: 20,
//         ),
//         buildTableCalender(_deviceSize, calenderController),
//         SizedBox(
//           height: 20,
//         ),
//         buidlAnotherline("Assigmnets"),
//         buildChipContent(),
//         buidlAnotherline("Notes"),
//         buildChipContent(),
//       ],
//     ),
//   );
// }

// Padding buildChipContent() {
//   return Padding(
//     padding: EdgeInsets.only(top: 15),
//     child: Wrap(
//       spacing: 3.0,
//       runSpacing: 2.0,
//       children: <Widget>[
//         buildChip("CN mod1"),
//         buildChip("ATC mod1,2,3"),
//         buildChip("M&E mod5"),
//         buildChip("DBMS ppt"),
//         buildChip("JAVA mod4"),
//         buildChip("C# mod3"),
//         buildChip("CN ppt"),
//         buildChip("DBMS mod3"),
//         buildChip("CN mod5")
//       ],
//     ),
//   );
// }

// Container buidlAnotherline(String name) {
//   return Container(
//     padding: EdgeInsets.all(12),
//     width: double.infinity,
//     decoration: BoxDecoration(
//       border: Border(
//         bottom: BorderSide(
//           width: 2.5,
//           color: Colors.black45,
//         ),
//       ),
//     ),
//     child: Center(
//       child: Text(
//         name,
//         style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//       ),
//     ),
//   );
// }

// buildTableCalender(
//     MediaQueryData _deviceSize, CalendarController calendarController) {
//   final Map<DateTime, List> _selectedDay = {
//     DateTime(2020, 1, 3): ['Selected Day in the calendar!'],
//     DateTime(2020, 1, 5): ['Selected Day in the calendar!'],
//     DateTime(2020, 1, 22): ['Selected Day in the calendar!'],
//     DateTime(2020, 1, 24): ['Selected Day in the calendar!'],
//     DateTime(2020, 1, 26): ['Selected Day in the calendar!'],
//   };

//   return
//       //  Container(
//       //   height: _deviceSize.size.height * 0.45,
//       //   width: double.infinity,
//       //   margin: EdgeInsets.all(7),
//       //   child: Center(child: Text("Calendar", style: TextStyle(fontSize: 30))),
//       //   color: Colors.blue,
//       // );

//       Container(
//     padding: EdgeInsets.only(top: 15),
//     // margin: EdgeInsets.all(5.0),
//     color: Color(0xff465466),
//     child: Column(
//       children: <Widget>[
//         Text(
//           "Calender Of Events",
//           style: TextStyle(
//               fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         SizedBox(
//           height: 15,
//         ),
//         TableCalendar(
//           calendarController: calendarController,
//           locale: 'en_US',
//           events: _selectedDay,
//           initialCalendarFormat: CalendarFormat.month,
//           formatAnimation: FormatAnimation.slide,
//           startingDayOfWeek: StartingDayOfWeek.sunday,
//           availableGestures: AvailableGestures.none,
//           availableCalendarFormats: const {
//             CalendarFormat.month: 'Month',
//           },
//           calendarStyle: CalendarStyle(
//             weekdayStyle: TextStyle(color: Colors.white),
//             weekendStyle: TextStyle(color: Colors.white),
//             outsideStyle: TextStyle(color: Colors.grey),
//             unavailableStyle: TextStyle(color: Colors.grey),
//             outsideWeekendStyle: TextStyle(color: Colors.grey),
//           ),
//           daysOfWeekStyle: DaysOfWeekStyle(
//             dowTextBuilder: (date, locale) {
//               return DateFormat.E(locale)
//                   .format(date)
//                   .substring(0, 3)
//                   .toUpperCase();
//             },
//             weekdayStyle: TextStyle(color: Colors.grey),
//             weekendStyle: TextStyle(color: Colors.grey),
//           ),
//           headerStyle: HeaderStyle(
//             titleTextStyle: TextStyle(color: Colors.white,fontSize: 20),
//             centerHeaderTitle: true,
//           ),
//           headerVisible: true,
//           builders: CalendarBuilders(
//             markersBuilder: (context, date, events, holidays) {
//               return [
//                 Container(
//                   decoration: new BoxDecoration(
//                     color: Color(0xFF30A9B2),
//                     shape: BoxShape.circle,
//                   ),
//                   margin: const EdgeInsets.all(2.0),
//                   width: 3,
//                   height: 3,
//                 )
//               ];
//             },
//             selectedDayBuilder: (context, date, _) {
//               return Container(
//                 decoration: new BoxDecoration(
//                   color: Color(0xFF30A9B2),
//                   shape: BoxShape.circle,
//                 ),
//                 margin: const EdgeInsets.all(1.0),
//                 width: 100,
//                 height: 100,
//                 child: Center(
//                   child: Text(
//                     '${date.day}',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Stack buildTimetable() {
//   return Stack(
//     alignment: Alignment.bottomCenter,
//     children: <Widget>[
//       Card(
//         child: Image.asset("assets/timetable.jpg"),
//       ),
//       Text(
//         "Main Time Table ",
//         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//       ),
//     ],
//   );
// }

// Padding buildAcademicListTile(
//     MediaQueryData _deviceSize, BuildContext context) {
//   return Padding(
//     padding: EdgeInsets.only(
//         top: _deviceSize.size.height * .02,
//         bottom: _deviceSize.size.height * .02),
//     child: ListTile(
//       onTap: () => Navigator.pushNamed(context, '/academics'),
//       leading: Icon(
//         Entypo.book,
//         size: 30,
//         color: Colors.black,
//       ),
//       title: Text(
//         "Academics",
//         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text("View your marks and attendance"),
//       trailing:
//           Icon(FontAwesome.arrow_circle_o_right, size: 30, color: Colors.black),
//     ),
//   );
// }
