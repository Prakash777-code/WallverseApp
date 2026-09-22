class UploadedWallpapers {
  final int id;
  final String imageUrl;
  final String title;

  UploadedWallpapers({
    required this.id,
    required this.imageUrl,
    required this.title,
  });

  factory UploadedWallpapers.fromJson(Map<String, dynamic> json) {
    return UploadedWallpapers(
      id: json["id"],
      title: json["title"],
      imageUrl: json["imageUrl"],
    );
  }
}
