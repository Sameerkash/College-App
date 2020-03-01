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
    ProfileLinks links;

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
      Map<dynamic, dynamic> links = data['links'];
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
        links: ProfileLinks.fromMap(links),
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

    factory ProfileLinks.fromMap(Map<dynamic, dynamic> data) {
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
