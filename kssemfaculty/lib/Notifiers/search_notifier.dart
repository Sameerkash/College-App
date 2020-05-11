import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:kssem/Models/users.dart';

class SearchNotifier with ChangeNotifier {
  List<Users> _userList = [];
  bool _querySuccess;

  UnmodifiableListView<Users> get users => UnmodifiableListView(_userList);
  get querySuccessstatus => _querySuccess;

  set usersList(List<Users> users) {
    _userList = users;
    notifyListeners();
  }

  set querySuccess(bool query) {
    _querySuccess = query;
    notifyListeners();
  }
}
