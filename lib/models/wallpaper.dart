class Wallpaper {
  int wallpaperId;
  String imageUrl;
  String photographer;

  Wallpaper({
    required this.wallpaperId,
    required this.imageUrl,
    required this.photographer
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json){
    return Wallpaper(
      wallpaperId: json["wallpaperId"],
      imageUrl: json["imageUrl"],
      photographer: json["photographer"]
    );
  }
}