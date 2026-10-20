class Community {
  final int userId;
  final int id;
  final String imageUrl;
  final String userName;
  int likes;

  Community({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.userName,
    required this.likes,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    print("ID: ${json["id"]}, isFavourite: ${json["isFavourite"]}");
    return Community(
      id: json["id"],
      userId: json["userId"],
      imageUrl: json["imageUrl"],
      userName: json["userName"],
      likes: json["_count"]?["likes"] ?? 0,
    );
  }
}
