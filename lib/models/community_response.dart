import 'package:wallverse/models/community.dart';

class CommunityResponse {
  List<Community> communityWallpapers;
  final int totalPosts;

  CommunityResponse({
    required this.communityWallpapers,
    required this.totalPosts,
  });

  factory CommunityResponse.fromJson(Map<String, dynamic> json) {
    return CommunityResponse(
      communityWallpapers: (json["data"] as List)
          .map((item) => Community.fromJson(item))
          .toList(),
      totalPosts: json["totalPosts"],
    );
  }
}
