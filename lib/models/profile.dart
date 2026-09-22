import 'package:flutter/foundation.dart';
import 'package:wallverse/models/uploaded_wallpapers.dart';

class Profile {
  final String name;
  final String email;
  final String memberSince;
  final int totalFavourites;
  final int totalUploads;
  final List<UploadedWallpapers> userUploads;

  Profile({
    required this.name,
    required this.email,
    required this.memberSince,
    required this.totalFavourites,
    required this.totalUploads,
    required this.userUploads,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json["name"],
      email: json["email"],
      memberSince: json["memberSince"],
      totalFavourites: json["totalFavourites"],
      totalUploads: json["totalUploads"],
      userUploads: (json["uploadedWallpapers"] as List)
          .map((wallpaper) => UploadedWallpapers.fromJson(wallpaper))
          .toList(),
    );
  }
}
