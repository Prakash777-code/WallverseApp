class Favourites {

  int id;
  int userId;
  int wallpaperId;
  String imageUrl;
  String photographer;

  Favourites({
    required this.id,
    required this.userId,
    required this.wallpaperId,
    required this.imageUrl,
    required this.photographer
  });

  factory Favourites.fromJson(Map<String, dynamic> json) {
    return Favourites(
      id: json["id"],
      userId: json["userId"],
      wallpaperId: int.parse(json["wallpaperId"].toString()),
      imageUrl: json["imageUrl"],
      photographer: json["photographer"],
    );
  }
}