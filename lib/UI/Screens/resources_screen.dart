import 'package:flutter/material.dart';
import '../Widgets/resoruces.dart';
import 'package:table_calendar/table_calendar.dart';

class ResourceScreen extends StatefulWidget {
  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  CalendarController calendarController;

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
      body: buildResoruces(context, calendarController),
    );
  }
}
