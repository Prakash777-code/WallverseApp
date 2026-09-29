class Wallpaper {
  int wallpaperId;
  String imageUrl;
  String photographer;
  bool isFavourite;

  Wallpaper({
    required this.wallpaperId,
    required this.imageUrl,
    required this.photographer,
    required this.isFavourite,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
      wallpaperId: json["wallpaperId"],
      imageUrl: json["imageUrl"],
      photographer: json["photographer"],
      isFavourite: json["isFavourite"] ?? false,
    );
  }
}
