import 'package:wallverse/models/get_favourites.dart';

class GetFavouritesResponse {
  List<GetFavourites> favourites;
  int totalFavourites;

  GetFavouritesResponse({
    required this.favourites,
    required this.totalFavourites,
  });

  factory GetFavouritesResponse.fromJson(Map<String, dynamic> json) {
    return GetFavouritesResponse(
      favourites: (json["data"] as List)
          .map((item) => GetFavourites.fromJson(item))
          .toList(),
      totalFavourites: json["totalFavourites"],
    );
  }
}
