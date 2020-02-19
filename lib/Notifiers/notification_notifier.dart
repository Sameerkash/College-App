import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../Models/notification.dart';

class NotificationNotifier with ChangeNotifier {
  List<Notification> _notificationListItems;

  UnmodifiableListView get notificationListItems =>
      UnmodifiableListView(_notificationListItems);
}
