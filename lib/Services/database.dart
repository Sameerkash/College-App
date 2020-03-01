import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:kssem/Models/notification.dart';
import 'package:path/path.dart' as path;
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
  deletePost(Post post);
  setPostImage(bool isUpdating,
      {UpdatePost updatePost,
      Post post,
      File localFile,
      bool isImageUpdated,
      bool isImageRemoved});
  setNotificationImage({
    Notifications notification,
    File localFile,
    bool isCollegeNotify,
    bool isDetNotify,
    String currentdepartment,
  });
  deleteNotification(
    Notifications currentNotification,
    String currentdepartment,
  );
  updateProfileLinks(Faculty faculty, ProfileLinks links);
  // addclassRoom(ClassRoom classRoom);
  // getClassRoom(ClassRoomNotifier classRooms);
  // getClassStudents(ClassRoom classRoom, ClassRoomNotifier classRoomNotify);
  // addStudentstoClass(ClassRoom classRoom, List<Student> selectedStudents);
  // getSelectedClassStudents(ClassRoomNotifier classRoomNotify);
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
  get timestamp => firestoreTimestamp;

  final _service = FirestoreService.instance;
  final firestoreTimestamp = Timestamp.now();

// The following methods up until getUserProfilePosts is used for handling all the database CRUD operatiojns for the forum of the app
// where users can upload a  post, edit a post, like a post and delete a post, they can also search for each user individually
// and go to their profile to see thier posts and like or unlike those posts along with data pagination.

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
      hasMorePosts = false;
    }

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

  setPostImage(bool isUpdating,
      {UpdatePost updatePost,
      Post post,
      File localFile,
      bool isImageUpdated,
      bool isImageRemoved}) async {
    if (localFile != null) {
      var fileExtension = path.extension(localFile.path);

      var uuid = Uuid().v4();

      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('posts/images/$uuid$fileExtension');

      await firebaseStorageRef
          .putFile(localFile)
          .onComplete
          .catchError((onError) {
        print(onError);
        return false;
      });

      String url = await firebaseStorageRef.getDownloadURL();

      setPost(isUpdating,
          updatePost: updatePost,
          post: post,
          imageUrl: url,
          isImageUpdated: isImageUpdated,
          isImageRemoved: isImageRemoved);
    } else {
      setPost(isUpdating,
          updatePost: updatePost,
          post: post,
          isImageRemoved: isImageRemoved,
          isImageUpdated: isImageUpdated);
    }
  }

  Future<void> setPost(
    bool isUpdating, {
    UpdatePost updatePost,
    Post post,
    String imageUrl,
    bool isImageRemoved,
    bool isImageUpdated,
  }) async {
    var uuid = Uuid().v4();
    final profileref = Firestore.instance.collection('posts/$uid/userPosts');

    final timelineref = Firestore.instance.collection('timeline');

    if (isUpdating) {
      updatePost.updatedAt = Timestamp.now();

      var deleteUrl = updatePost.imageUrl;

      if (isImageRemoved == true && deleteUrl != null) {
        // print("IMAGEDeleted called");
        StorageReference storageReference =
            await FirebaseStorage.instance.getReferenceFromUrl(deleteUrl);
        await storageReference.delete();
        updatePost.imageUrl = null;
      }

      if (isImageUpdated == true) {
        // print("isupdated $isImageUpdated");

        if (deleteUrl != null) {
          StorageReference storageReference =
              await FirebaseStorage.instance.getReferenceFromUrl(deleteUrl);
          await storageReference.delete();
          updatePost.imageUrl = imageUrl;
        }
        updatePost.imageUrl = imageUrl;
      }

      if (isImageUpdated == false &&
          isImageRemoved == false &&
          imageUrl != null) {
        // print("imageUrl $imageUrl");
        updatePost.imageUrl = imageUrl;
      }

      // print(post.postId);
      await profileref
          .document(updatePost.postId)
          .updateData(updatePost.toUpdateMap());
      await timelineref
          .document(updatePost.postId)
          .updateData(updatePost.toUpdateMap());
    } else {
      post.imageUrl = imageUrl;
      post.createdAt = Timestamp.now();
      post.postId = uuid;
      await profileref.document('$uuid').setData(post.toMap(), merge: true);
      await timelineref.document('$uuid').setData(post.toMap(), merge: true);
      print(post.postId);
    }
  }

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
    if (post.imageUrl != null) {
      StorageReference storageReference =
          await FirebaseStorage.instance.getReferenceFromUrl(post.imageUrl);

      // print(storageReference.path);

      await storageReference.delete();
    }
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

// Notification database methods

  setNotificationImage({
    Notifications notification,
    File localFile,
    bool isCollegeNotify,
    bool isDetNotify,
    String currentdepartment,
  }) async {
    if (localFile != null) {
      var fileExtension = path.extension(localFile.path);

      var uuid = Uuid().v4();

      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('notifications/images/$uuid$fileExtension');

      await firebaseStorageRef
          .putFile(localFile)
          .onComplete
          .catchError((onError) {
        print(onError);
        return false;
      });

      String url = await firebaseStorageRef.getDownloadURL();
      setNotification(notification,
          isCollegeNotify: isCollegeNotify,
          isDetNotify: isDetNotify,
          url: url,
          currentdepartment: currentdepartment);
    } else {
      setNotification(notification,
          isCollegeNotify: isCollegeNotify,
          isDetNotify: isDetNotify,
          currentdepartment: currentdepartment);
    }
  }

  setNotification(Notifications notification,
      {bool isCollegeNotify,
      bool isDetNotify,
      String currentdepartment,
      String url}) async {
    if (url != null) {
      notification.imageUrl = url;
    }

    var nid = Uuid().v4();
    notification.nid = nid;
    notification.createdAt = Timestamp.now();
    notification.department = currentdepartment;

    if (isDetNotify == true && isCollegeNotify == false) {
      final departmentref = Firestore.instance
          .collection('departments')
          .document('$currentdepartment')
          .collection('notifications');

      departmentref.document('$nid').setData(notification.toMap());
    } else if (isCollegeNotify == true && isDetNotify == false) {
      final ref = Firestore.instance;

      ref
          .collection('departments')
          .document('CSE')
          .collection('notifications')
          .document('$nid')
          .setData(notification.toMap());
      ref
          .collection('departments')
          .document('ECE')
          .collection('notifications')
          .document('$nid')
          .setData(notification.toMap());
      ref
          .collection('departments')
          .document('CIV')
          .collection('notifications')
          .document('$nid')
          .setData(notification.toMap());
      ref
          .collection('departments')
          .document('MECH')
          .collection('notifications')
          .document('$nid')
          .setData(notification.toMap());
      ref
          .collection('departments')
          .document('EEE')
          .collection('notifications')
          .document('$nid')
          .setData(notification.toMap());
    }
  }

  deleteNotification(
    Notifications currentNotification,
    String currentdepartment,
  ) async {
    if (currentNotification.imageUrl != null) {
      StorageReference storageReference = await FirebaseStorage.instance
          .getReferenceFromUrl(currentNotification.imageUrl);

      // print(storageReference.path);

      await storageReference.delete();
    }
    if (currentNotification.isCollegeNotification) {
      final ref = Firestore.instance;

      ref
          .collection('departments')
          .document('CSE')
          .collection('notifications')
          .document(currentNotification.nid)
          .delete();
      ref
          .collection('departments')
          .document('ECE')
          .collection('notifications')
          .document(currentNotification.nid)
          .delete();
      ref
          .collection('departments')
          .document('CIV')
          .collection('notifications')
          .document(currentNotification.nid)
          .delete();
      ref
          .collection('departments')
          .document('MECH')
          .collection('notifications')
          .document(currentNotification.nid)
          .delete();
      ref
          .collection('departments')
          .document('EEE')
          .collection('notifications')
          .document(currentNotification.nid)
          .delete();
    }
    final profileref = Firestore.instance
        .collection('departments/$currentdepartment/notifications');
    // final timelineref = Firestore.instance.collection('timeline');

    await profileref.document(currentNotification.nid).delete();
    // await timelineref.document(cure.postId).delete();
    // postDeleted();
  }

  updateProfileLinks(Faculty faculty, ProfileLinks links) async {
    final ref = Firestore.instance.collection('faculty');
    print(links.description);
    await ref.document('${faculty.uid}').updateData({
      'links.description': links.description,
      'links.github': links.github,
      'links.stackOverflow': links.stackOverflow,
      'links.linkedIn': links.linkedIn,
      'links.link': links.link
    });
  }

// Notification ends
  // This marks the end of the methods for the forum

  // The following methods below are used to the deal with the CRUD operations for the Academic Screen Where Teachers will
  // Handle operations such as adding classrooms, adding subjects and students for the respective classrooms and marking the
  // attendance and the marks of each student for each subject.

  // addclassRoom(ClassRoom classRoom) async {
  //   final ref = Firestore.instance
  //       .collection('departments')
  //       .document('${classRoom.department}')
  //       .collection('${classRoom.batch}')
  //       .document('${classRoom.className}');
  //   await ref.setData(classRoom.toMap());
  // }

  // getClassRoom(ClassRoomNotifier classRooms) async {
  //   final snapshot = await Firestore.instance
  //       .collection('departments')
  //       .document('CSE')
  //       .collection('2017')
  //       .getDocuments();

  //   final snapshottwo = await Firestore.instance
  //       .collection('departments')
  //       .document('CSE')
  //       .collection('2018')
  //       .getDocuments();

  //   // .document('${classRoom.className}');
  //   List<ClassRoom> _classess = [];
  //   snapshot.documents.forEach((doc) {
  //     ClassRoom _classRoom = ClassRoom.fromMap(doc.data);
  //     _classess.add(_classRoom);
  //   });
  //   snapshottwo.documents.forEach((doc) {
  //     ClassRoom _classRoom = ClassRoom.fromMap(doc.data);
  //     _classess.add(_classRoom);
  //   });
  //   classRooms.classRooms = _classess;
  // }

  // getClassStudents(
  //     ClassRoom classRoom, ClassRoomNotifier classRoomNotify) async {
  //   // print(classRoom.batch);
  //   // print(classRoom.department);
  //   final snapshot = await Firestore.instance
  //       .collection('students')
  //       .where('classKey', isEqualTo: classRoom.classKey)
  //       .orderBy('usn')
  //       .getDocuments();
  //   // print(snapshot.documents.length);
  //   List<Student> _clasStudents = [];
  //   snapshot.documents.forEach((doc) {
  //     Student _student = Student.fromMap(doc.data);
  //     _clasStudents.add(_student);
  //   });
  //   classRoomNotify.classStudents = _clasStudents;
  // }

  // addStudentstoClass(
  //     ClassRoom classRoom, List<Student> selectedStudents) async {
  //   final snapshot = Firestore.instance
  //       .collection('departments')
  //       .document(classRoom.department)
  //       .collection(classRoom.batch)
  //       .document(classRoom.className)
  //       .collection('students');

  //   selectedStudents.forEach((data) async {
  //     await snapshot.document(data.uid).setData(data.toMap());
  //   });
  // }

  // getSelectedClassStudents(ClassRoomNotifier classRoomNotify) async {
  //   final snapshot = await Firestore.instance
  //       .collection('departments')
  //       .document(classRoomNotify.currentClass.department)
  //       .collection(classRoomNotify.currentClass.batch)
  //       .document(classRoomNotify.currentClass.className)
  //       .collection('students')
  //       .getDocuments();

  //   List<Student> _clasStudents = [];
  //   snapshot.documents.forEach((doc) {
  //     Student _student = Student.fromMap(doc.data);
  //     _clasStudents.add(_student);
  //   });
  //   classRoomNotify.selectedStudentsList = _clasStudents;
  // }
}
