import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  String postId;
  final String userName;
  final String photoUrl;
  final String content;
  final String title;
  Timestamp createdAt;
  Timestamp updatedAt;
  Map likes;

  Post({
    this.uid,
    this.postId,
    this.userName,
    this.photoUrl,
    this.content,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.likes,
  });

  factory Post.fromMap(
    Map<String, dynamic> data,
  ) {
    if (data == null) {
      return null;
    }
    final String uid = data['uid'];
    String postId = data['postId'];
    final String userName = data['userName'];
    final String photoUrl = data['photoUrl'];
    final String content = data['content'];
    final String title = data['title'];
    Timestamp createdAt = data['createdAt'];
    Timestamp updatedAt = data['updatedat'];
    final Map likes = data["likes"];
    return Post(
        uid: uid,
        postId: postId,
        userName: userName,
        photoUrl: photoUrl,
        content: content,
        title: title,
        createdAt: createdAt,
        updatedAt: updatedAt,
        likes: likes);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'postId': postId,
      'userName': userName,
      'photoUrl': photoUrl,
      'content': content,
      'title': title,
      'createdAt': createdAt,
      'updatedat': updatedAt,
      'likes': {},
    };
  }
   Map<String, dynamic> toUpdateMap() {
    return {
     
      'postId': postId,
      // 'userName': userName,
      // 'photoUrl': photoUrl,
      'content': content,
      'title': title,
      'createdAt': createdAt,
      'updatedat': updatedAt,
      // 'likes': {},
    };
  }
}


class UpdatePost {
  // final String uid;
  String postId;
  // final String userName;
  // final String photoUrl;
  final String content;
  final String title;
  // Timestamp createdAt;
  Timestamp updatedAt;
  // Map likes;

  UpdatePost({
    // this.uid,
    this.postId,
    // this.userName,
    // this.photoUrl,
    this.content,
    this.title,
    // this.createdAt,
    this.updatedAt,
    // this.likes,
  });

  Map<String, dynamic> toUpdateMap() {
    return {
      'postId': postId,
      // 'userName': userName,
      // 'photoUrl': photoUrl,
      'content': content,
      'title': title,
      // 'createdAt': createdAt,
      'updatedat': updatedAt,
      // 'likes': {},
    };
  }
}

