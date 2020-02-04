import 'package:flutter/foundation.dart';

class Faculty {
  final String uid;
  final String name;
  final String displayName;
  final String facultyId;
  final String email;
  final String phone;
  final String department;
  final String designation;
  String photoUrl;
  dynamic links;
  dynamic posts;

  Faculty({
    @required this.uid,
    this.facultyId,
    /*@required*/ this.name,
    this.displayName,
    /*@required*/ this.email,
    /*@required*/ this.phone,
    /*@required*/ this.department,
    /*@required*/ this.designation,
    this.photoUrl,
    this.links,
    this.posts,
  });

  factory Faculty.fromMap(Map<String, dynamic> data, String id) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String displayName = data['displayName'];
    final String facultyId = data['facultyId'];
    final String email = data['email'];
    final String phone = data['phone'];
    final String department = data['department'];
    final String designation = data['designation'];
    final String photoUrl = data['photoUrl'];
    dynamic links = data['links'];
    dynamic posts = data['pots'];
    return Faculty(
      uid: id,
      facultyId: facultyId,
      name: name,
      displayName: displayName,
      phone: phone,
      email: email,
      department: department,
      photoUrl: photoUrl,
      designation: designation,
      links: links,
      posts: posts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'facultyId': facultyId ?? '',
      'name': name ?? '',
      'displayName': displayName ?? '',
      'phone': phone ?? '',
      'email': email ?? '',
      'department': department ?? '',
      'designation': designation ?? '',
      'photoUrl': photoUrl ?? '',
      'links': links ?? '',
      'posts': posts ?? ''
    };
  }
}
