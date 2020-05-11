import 'package:flutter/foundation.dart';
import 'package:kssem/Models/faculty.dart';

class Student {
  final String uid;
  final String name;
  final String displayName;
  final String usn;
  final String email;
  final String phone;
  final String branch;
  final String batch;
  final String classKey;
  final String degree;
  String photoUrl;
  ProfileLinks links;
  // dynamic posts;

  Student({
    @required this.uid,
    this.usn,
    /*@required*/ this.name,
    this.displayName,
    /*@required*/ this.email,
    /*@required*/ this.phone,
    /*@required*/ this.branch,
    /*@required*/ this.degree,
    this.batch,
    this.classKey,
    this.photoUrl,
    this.links,
    // this.posts,
  });

  factory Student.fromMap(Map<String, dynamic> data, String id) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String displayName = data['displayName'];
    final String usn = data['usn'];
    final String email = data['email'];
    final String phone = data['phone'];
    final String branch = data['branch'];
    final String degree = data['degree'];
    final String photoUrl = data['photoUrl'];
    final String batch = data['batch'];
    final String classKey = data['classKey'];
    Map<dynamic, dynamic> links = data['links'];
    // dynamic posts = data['pots'];
    return Student(
        uid: id,
        usn: usn,
        name: name,
        displayName: displayName,
        phone: phone,
        email: email,
        branch: branch,
        photoUrl: photoUrl,
        degree: degree,
        links: ProfileLinks.fromMap(links),
        batch: batch,
        classKey: classKey

        // posts: posts,
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'usn': usn ?? '',
      'name': name ?? '',
      'displayName': displayName ?? '',
      'phone': phone ?? '',
      'email': email ?? '',
      'branch': branch ?? '',
      'degree': degree ?? '',
      'photoUrl': photoUrl ?? '',
      'links': {},
      'batch': batch,
      'classKey': classKey,
      // 'posts': posts ?? ''
    };
  }
}
