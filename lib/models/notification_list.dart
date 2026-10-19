class NotificationList {
  final int id;
  final String imageUrl;
  final String userName;
  final String created_at;

  NotificationList({
    required this.id,
    required this.imageUrl,
    required this.userName,
    required this.created_at,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) {
    return NotificationList(
      id: json["id"],
      imageUrl: json["imageUrl"],
      userName: json["userName"],
      created_at: json["created_at"],
    );
  }
}
