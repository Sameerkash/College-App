import 'package:flutter/foundation.dart';

class Student {
  final String uid;
  final String name;
  final String displayName;
  final String usn;
  final String email;
  final String phone;
  final String branch;
  final String degree;
  final String batch;
  String photoUrl;
  ProfileLinks links;

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
    this.photoUrl,
    this.links,
  });

  factory Student.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String uid = data['uid'];
    final String name = data['name'];
    final String displayName = data['displayName'];
    final String usn = data['usn'];
    final String email = data['email'];
    final String phone = data['phone'];
    final String branch = data['branch'];
    final String degree = data['degree'];
    final String photoUrl = data['photoUrl'];
    final String batch = data['batch'];
    dynamic links = data['links'];
    return Student(
      uid: uid,
      usn: usn,
      name: name,
      displayName: displayName,
      phone: phone,
      email: email,
      branch: branch,
      photoUrl: photoUrl,
      degree: degree,
      batch: batch,
      links: ProfileLinks.fromMap(links),
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
      'batch': batch,
      'photoUrl': photoUrl ?? '',
      'links': {},
    };
  }
}

class ProfileLinks {
  String description;
  String github;
  String stackOverflow;
  String linkedIn;
  String link;

  ProfileLinks(
      {this.description,
      this.github,
      this.stackOverflow,
      this.link,
      this.linkedIn});

  factory ProfileLinks.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String description = data['description'];
    final String github = data['github'];
    final String stackOverflow = data['stackOverflow'];
    final String linkedIn = data['linkedIn'];

    final String link = data['link'];
    return ProfileLinks(
      description: description,
      github: github,
      stackOverflow: stackOverflow,
      linkedIn: linkedIn,
      link: link,
    );
  }

  Map<String, dynamic> toUpdateProfile() {
    return {
      'links.description': description,
      'links.github': github,
      'links.stackOverflow': stackOverflow,
      'links.linkedIn': linkedIn,
      'links.link': link
    };
  }
}
