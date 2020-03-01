import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  String nid;
  final String uid;
  // final String title;
  final String facultyName;
  String imageUrl;
  final String content;
  Timestamp createdAt;
  final String storedDepartment;
  String department;
  bool isCollegeNotification;

  Notifications(
      {this.nid,
      this.uid,
      // this.title,
      this.facultyName,
      this.imageUrl,
      this.createdAt,
      this.storedDepartment,
      this.department,
      this.content,
      this.isCollegeNotification});

  factory Notifications.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String nid = data['nid'];
    final String uid = data['uid'];
    final String imageUrl = data['imageUrl'];
    // final String title = data['title'];
    final String facultyName = data['facultyName'];
    final String content = data['content'];
    Timestamp createdAt = data['createdAt'];
    final String storedDepartment = data['storedDepartment'];
    final String department = data['department'];
    final bool isCollegeNotification = data['isCollegeNotification'];
    return Notifications(
        nid: nid,
        uid: uid,
        // title: title,
        imageUrl: imageUrl,
        department: department,
        content: content,
        createdAt: createdAt,
        storedDepartment: storedDepartment,
        isCollegeNotification: isCollegeNotification,
        facultyName: facultyName);
  }

  Map<String, dynamic> toMap() {
    return {
      'nid': nid,
      'uid': uid,
      // 'title': title,
      'imageUrl': imageUrl ?? "",
      'facultyName': facultyName,
      'content': content,
      'createdAt': createdAt,
      'storedDepartment': storedDepartment,
      'department': department,
      'isCollegeNotification': isCollegeNotification,
    };
  }
}
