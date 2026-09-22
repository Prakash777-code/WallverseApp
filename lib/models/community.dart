class Community {
  final int userId;
  final int id;
  final String imageUrl;
  final String userName;
  int likes;
  bool isLiked;
  bool isFavourite;

  Community({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.userName,
    required this.likes,
    required this.isLiked,
    required this.isFavourite,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    print("ID: ${json["id"]}, isFavourite: ${json["isFavourite"]}");
    return Community(
      id: json["id"],
      userId: json["userId"],
      imageUrl: json["imageUrl"],
      userName: json["userName"],
      likes: json["likes"] ?? 0,
      isLiked: json["isLiked"] ?? false,
      isFavourite: json["isFavourite"] ?? false,
    );
  }
}
