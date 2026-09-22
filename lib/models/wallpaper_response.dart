import 'package:wallverse/models/wallpaper.dart';

class WallpaperResponse {
  final List<Wallpaper> wallpaper;
  final int totalResults;

  WallpaperResponse({required this.wallpaper, required this.totalResults});

  factory WallpaperResponse.fromJson(Map<String, dynamic> json) {
    return WallpaperResponse(
      wallpaper: (json["data"] as List)
          .map((item) => Wallpaper.fromJson(item))
          .toList(),
      totalResults: json["totalResults"],
    );
  }
}
