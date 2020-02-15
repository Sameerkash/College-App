import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:kssem/Models/class.dart';
import 'package:kssem/Models/student.dart';

class ClassRoomNotifier with ChangeNotifier {
  List<ClassRoom> _classes = [];
  List<Student> _students = [];
  List<Student> _selectedStudents = [];
  ClassRoom _currentClass;

  UnmodifiableListView<ClassRoom> get classRooms =>
      UnmodifiableListView(_classes);
  UnmodifiableListView<Student> get classStudentsList =>
      UnmodifiableListView(_students);
  ClassRoom get currentClass => _currentClass;

  set classRooms(List<ClassRoom> classess) {
    _classes = classess;
    notifyListeners();
  }

  set currentClasRoom(ClassRoom classRoom) {
    _currentClass = classRoom;
    notifyListeners();
  }

  set classStudents(List<Student> students) {
    _students = students;
    notifyListeners();
  }

  set selectedStudentsList(List<Student> students) {
    _selectedStudents.addAll(students);
  }
}
