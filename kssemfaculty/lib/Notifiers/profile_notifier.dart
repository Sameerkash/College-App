import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:kssem/Models/post.dart';
import 'package:kssem/Models/faculty.dart';

class ProfileNotifier with ChangeNotifier {
  List<Post> _post = [];
  Post _currentPost;
  Faculty _faculty;

  UnmodifiableListView<Post> get posts => UnmodifiableListView(_post);
  Post get currentPost => _currentPost;
  Faculty get currentFaculty => _faculty;

  set setFacultyProfile(Faculty faculty) {
    _faculty = faculty;
    notifyListeners();
  }

  set profilePostList(List<Post> posts) {
    _post = posts;
    notifyListeners();
  }

  set updateProfilePostList(List<Post> posts) {
    _post.addAll(posts);
    notifyListeners();
  }

  set currentProfilePost(Post currentPost) {
    _currentPost = currentPost;
    notifyListeners();
  }

  deletePost(Post post) {
    _post.removeWhere((_posts) => _posts.postId == post.postId);
    notifyListeners();
  }
}
