class GetFavourites {
  final int id;
  final int userId;
  final String wallpaperId;
  final String imageUrl;
  final String photographer;
  final String createdAt;

  GetFavourites({
    required this.id,
    required this.userId,
    required this.wallpaperId,
    required this.imageUrl,
    required this.photographer,
    required this.createdAt,
  });

  factory GetFavourites.fromJson(Map<String, dynamic> json) {
    return GetFavourites(
      id: json["id"],
      userId: json["userId"],
      wallpaperId: json["wallpaperId"].toString(),
      imageUrl: json["imageUrl"],
      photographer: json["photographer"],
      createdAt: json["created_at"],
    );
  }
}
