import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:kssem/Models/post.dart';

class TimelineNotifer with ChangeNotifier {
  List<Post> _timelinePost = [];
  Post _currentTimelinePost;
  // Student _student;

  UnmodifiableListView<Post> get timelinePosts =>
      UnmodifiableListView(_timelinePost);
  Post get currentTimelinePost => _currentTimelinePost;
  // Student get student => _student;

  // set setStudentProfile(Student student) {
  //   _student = student;
  //   notifyListeners();
  // }

  set timelinePostList(List<Post> timelinePosts) {
    _timelinePost = timelinePosts;
    notifyListeners();
  }

  set updateTimelinePostList(List<Post> timelinePosts) {
    _timelinePost.addAll(timelinePosts);
    notifyListeners();
  }

  set currentProfilePost(Post post) {
    _currentTimelinePost = currentTimelinePost;
    notifyListeners();
  }

  deletePost(Post timelinePost) {
    _timelinePost.removeWhere(
        (_timelinePosts) => _timelinePosts.postId == timelinePost.postId);
        notifyListeners();
  }
}
