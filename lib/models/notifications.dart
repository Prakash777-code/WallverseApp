import 'package:wallverse/models/notification_list.dart';

class Notifications {
  List<NotificationList> notificationList;
  final int totalNotifications;

  Notifications({
    required this.notificationList,
    required this.totalNotifications,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      notificationList: (json["data"] as List)
          .map((item) => NotificationList.fromJson(item))
          .toList(),
      totalNotifications: json["totalNotifications"],
    );
  }
}
