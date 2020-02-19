import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String facultyName;
  final String content;
  Timestamp createdAt;
  final String storedDepartment;
  final String department;

  Notification({
    this.facultyName,
    this.createdAt,
    this.storedDepartment,
    this.department,
    this.content,
  });

  factory Notification.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String facultyName = data['facultyName'];
    final String content = data['content'];
    Timestamp createdAt = data['createdAt'];
    final String storedDepartment = data['storedDepartment'];
    final String department = data['department'];
    return Notification(
        department: department,
        content: content,
        createdAt: createdAt,
        storedDepartment: storedDepartment,
        facultyName: facultyName);
  }

  Map<String, dynamic> toMap() {
    return {
      'facultyName': facultyName,
      'content': content,
      'createdAt': createdAt,
      'storedDepartment': storedDepartment,
      'department': department,
    };
  }
}
