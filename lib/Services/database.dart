import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../Models/post.dart';
import '../Models/faculty.dart';
import '../Models/users.dart';
import '../Notifiers/profile_notifier.dart';
import '../Notifiers/search_notifier.dart';
import '../Notifiers/timeline_notifier.dart';
import '../Services/authentication.dart';
import '../Services/firestore_service.dart';
import 'package:uuid/uuid.dart';

abstract class Database {
  Future<void> setFaculty(Faculty faculty);
  getFaculty();
  Future<void> setPost(bool isUpdating,
      {UpdatePost updatePost,
      Post post}); // Future<void> setTimeline(Post post, bool isUpdating);
  getPosts(ProfileNotifier post);
  getFacultyProfile(ProfileNotifier faculty);
  getTimeline(TimelineNotifer timelinePosts);
  getMoreTimeline(TimelineNotifer timelinePosts);
  getMoreProfilePosts(ProfileNotifier posts);
  likePost(Post post);
  unLikePost(Post post);
  handleSearch(String query, SearchNotifier students);
  getUserProfilePosts(Users user);
  deletePost(
    Post post,
  );
  get userId;
  // get dateTime;
  get timestamp;
  get photoUrl;
  get displayName;
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid, this.user}) : assert(uid != null);
  final String uid;
  User user;
  get displayName => user.displayName;
  get photoUrl => user.photoUrl;
  get userId => uid;
  // get dateTime => date();
  get timestamp => firestoreTimestamp;

  final _service = FirestoreService.instance;
  // String date() => DateTime.now().toIso8601String();
  final firestoreTimestamp = Timestamp.now();

  // checkStudentprofile() async {
  //   final ref =
  //       await Firestore.instance.collection('students').document('$uid').get();
  //   return Student.fromMap(ref.data, uid);
  // }

  @override
  Future<void> setFaculty(Faculty faculty) async => await _service.setData(
        path: 'faculty/$uid/',
        data: faculty.toMap(),
      );

  DocumentSnapshot lastPostDocument;
  bool hasMorePosts = true;
  bool gettingPostsList = false;

  getPosts(ProfileNotifier posts) async {
    final ref = Firestore.instance;
    final snapshot = await ref
        .collection('posts/$uid/userPosts')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .getDocuments();
    List<Post> _posts = [];
    snapshot.documents.forEach((document) {
      Post pos = Post.fromMap(document.data);
      _posts.add(pos);
    });
    if (snapshot.documents.length < 10) {
      // print(snapshot.documents.length);
      hasMorePosts = false;
    }
    // print(snapshot.documents.length);
    if (snapshot.documents.length == 0) {
      return;
    } else {
      lastPostDocument = snapshot.documents[snapshot.documents.length - 1];
    }

    posts.profilePostList = _posts;
  }

  getMoreProfilePosts(ProfileNotifier posts) async {
    if (gettingPostsList) {
      return;
    }

    if (!hasMorePosts) {
      // print('No More posts');
      return;
    }

    gettingPostsList = true;

    final ref = Firestore.instance;
    final snapshot = await ref
        .collection('posts/$uid/userPosts')
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastPostDocument)
        .limit(10)
        .getDocuments();
    List<Post> _posts = [];
    snapshot.documents.forEach((document) {
      Post pos = Post.fromMap(document.data);
      _posts.add(pos);
    });
    posts.updateProfilePostList = _posts;

    if (snapshot.documents.length < 10) {
      hasMorePosts = false;
    }
    // if (snapshot.documents.length == 0 | 1) {
    //   return;
    // }
    if (snapshot.documents.length == 0) {
      return;
    } else {
      lastPostDocument = snapshot.documents[snapshot.documents.length - 1];
    }
    gettingPostsList = false;
  }

  Future<Faculty> getFaculty() async {
    final reference = Firestore.instance;
    final refresult =
        await reference.collection('faculty').document('$uid').get();

    return Faculty.fromMap(refresult.data, uid);
  }

  getFacultyProfile(ProfileNotifier faculty) async {
    final reference = Firestore.instance;
    final document =
        await reference.collection('faculty').document('$uid').get();
    Faculty _faculty = Faculty.fromMap(document.data, uid);
    faculty.setFacultyProfile = _faculty;
  }

  Future<void> setPost(bool isUpdating,
      {UpdatePost updatePost, Post post}) async {
    var uuid = Uuid().v4();
    final profileref = Firestore.instance.collection('posts/$uid/userPosts');

    final timelineref = Firestore.instance.collection('timeline');

    if (isUpdating) {
      updatePost.updatedAt = Timestamp.now();
      // print(post.postId);
      await profileref
          .document(updatePost.postId)
          .updateData(updatePost.toUpdateMap());
      await timelineref
          .document(updatePost.postId)
          .updateData(updatePost.toUpdateMap());
    } else {
      post.createdAt = Timestamp.now();
      post.postId = uuid;
      await profileref.document('$uuid').setData(post.toMap(), merge: true);
      await timelineref.document('$uuid').setData(post.toMap(), merge: true);
      print(post.postId);
    }
  }

  // Future<void> setTimeline(Post post, bool isUpdating) async {
  //   final timelineref = Firestore.instance.collection('timeline');

  //   if (isUpdating) {
  //     post.updatedAt = Timestamp.now();
  //     await ref.document(post.postId).updateData(post.toMap());
  //   } else {
  //     post.createdAt = Timestamp.now();
  //     DocumentReference documentRef = await ref.add(post.toMap());
  //     post.postId = documentRef.documentID;
  //     await documentRef.setData(post.toMap(), merge: true);
  //   }
  // }

  DocumentSnapshot lastDocument;
  bool hasMore = true;
  bool gettingList = false;

  getTimeline(TimelineNotifer timelinePosts) async {
    final ref = Firestore.instance;
    final snapshot = await ref
        .collection('timeline')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .getDocuments();

    List<Post> _posts = [];
    snapshot.documents.forEach((document) {
      Post pos = Post.fromMap(document.data);
      _posts.add(pos);
    });

    if (snapshot.documents.length < 20) {
      // print(snapshot.documents.length);
      hasMore = false;
    }

    lastDocument = snapshot.documents[snapshot.documents.length - 1];

    timelinePosts.timelinePostList = _posts;
  }

  getMoreTimeline(TimelineNotifer timelinePosts) async {
    // print("get moretimeliene called");
    // print(gettingList);
    if (gettingList) {
      // print("if block getting list");
      return;
    }

    if (!hasMore) {
      // print('No More posts');
      return;
    }

    gettingList = true;
    final ref = Firestore.instance;
    final snapshot = await ref
        .collection('timeline')
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastDocument)
        .limit(20)
        .getDocuments();

    List<Post> _posts = [];
    snapshot.documents.forEach((document) {
      Post pos = Post.fromMap(document.data);
      _posts.add(pos);
    });
    // print(snapshot.documents.length);

    timelinePosts.updateTimelinePostList = _posts;

    if (snapshot.documents.length < 20) {
      hasMore = false;
    }

    lastDocument = snapshot.documents[snapshot.documents.length - 1];

    gettingList = false;
  }

  deletePost(
    Post post,
  ) async {
    final profileref = Firestore.instance.collection('posts/$uid/userPosts');
    final timelineref = Firestore.instance.collection('timeline');

    await profileref.document(post.postId).delete();
    await timelineref.document(post.postId).delete();
    // postDeleted();
  }

  unLikePost(Post post) async {
    final profileref =
        Firestore.instance.collection('posts/${post.uid}/userPosts');
    final timelineref = Firestore.instance.collection('timeline');

    await profileref.document(post.postId).updateData({'likes.$userId': false});
    await timelineref
        .document(post.postId)
        .updateData({'likes.$userId': false});
  }

  likePost(Post post) async {
    final profileref =
        Firestore.instance.collection('posts/${post.uid}/userPosts');
    final timelineref = Firestore.instance.collection('timeline');

    await profileref.document(post.postId).updateData({'likes.$userId': true});
    await timelineref.document(post.postId).updateData({'likes.$userId': true});
  }

  handleSearch(String query, SearchNotifier users) async {
    final studentSnapshot = await Firestore.instance
        .collection('students')
        .where('displayName', isGreaterThanOrEqualTo: query)
        .getDocuments();
    final facultySnapShot = await Firestore.instance
        .collection('faculty')
        .where('displayName', isGreaterThanOrEqualTo: query)
        .getDocuments();
    // print(studentSnapshot.documents.length);
    // print(facultySnapShot.documents.length);

    if (studentSnapshot.documents.isEmpty &&
        facultySnapShot.documents.isEmpty) {
      users.querySuccess = false;
    } else {
      users.querySuccess = true;
    }

    List<Users> _usersList = [];
    studentSnapshot.documents.forEach((doc) {
      Users _users = Users.fromStudentMap(doc.data);
      _usersList.add(_users);
    });
    facultySnapShot.documents.forEach((doc) {
      Users _facultyUsers = Users.fromFacultyMap(doc.data);
      _usersList.add(_facultyUsers);
    });

    users.usersList = _usersList;
  }

  getUserProfilePosts(Users user) async {
    final snapshot = await Firestore.instance
        .collection('posts/${user.uid}/userPosts')
        .orderBy('createdAt', descending: true)
        .getDocuments();
    return snapshot;
  }
}
