import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:kssem/Models/users.dart';

class SearchNotifier with ChangeNotifier {
  List<Users> _userList = [];
  bool _querySuccess;

  UnmodifiableListView<Users> get users => UnmodifiableListView(_userList);
  get querySuccessstatus => _querySuccess;

  set studentsList(List<Users> students) {
    _userList = students;
    notifyListeners();
  }

  set querySuccess(bool query) {
    _querySuccess = query;
    notifyListeners();
  }
}
