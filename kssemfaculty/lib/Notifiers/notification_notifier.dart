// import 'dart:collection';

// import 'package:flutter/foundation.dart';

// import '../Models/notification.dart';

// class NotificationNotifier with ChangeNotifier {
//   List<Notifications> _notificationListItems;
//   Notifications _currentNotification;

//   String _currentDept;

//   UnmodifiableListView get notificationListItems =>
//       UnmodifiableListView(_notificationListItems);

//   Notifications get currentNotification => _currentNotification;

//   get currentDept => _currentDept;

//   set currentNotify(Notifications notification) {
//     _currentNotification = notification;
//     notifyListeners();
//   }

//   // set notificationList(List<Notifications> notifications) {
//   //   _notificationListItems = notifications;
//   //   notifyListeners();
//   // }

//   set curentDeptSetter(String curentDept) {
//     _currentDept = curentDept;
//     notifyListeners();
//   }
// }
