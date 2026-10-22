import 'package:flutter/material.dart';
import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/models/favourites.dart';
import 'package:wallverse/models/wallpaper.dart';
import 'package:wallverse/models/wallpaper_response.dart';
import 'package:wallverse/repositories/wallpaper_repository.dart';
import 'package:wallverse/utils/helper.dart';

class HomeViewmodel extends ChangeNotifier {
  final wallpaperRepository = WallpaperRepository();
  List<Wallpaper> wallpapers = [];
  List<Favourites> favouriteWallpapers = [];
  Set<int> favouritesIds = {};
  bool isLoading = false;
  bool clickLoader = false;
  bool isDownloading = false;
  String? errorMessage;
  bool retry = false;
  int limit = 16;
  int currentPage = 1;
  bool isLoadingMore = false;
  int totalResults = 0;
  String Query = "nature";
  final helper = Helper();

  Future<void> loadMoreWallpapers() async {
    if (isLoadingMore) {
      return;
    }
    if (wallpapers.length >= totalResults) {
      return;
    }
    final nextPage = currentPage + 1;
    isLoadingMore = true;
    errorMessage = null;
    notifyListeners();
    try {
      final moreWallpapers = await wallpaperRepository.getWallpapers(
        Query,
        nextPage,
        limit,
      );
      final response = moreWallpapers.data as WallpaperResponse;
      final wallpaperIds = response.wallpaper
          .map((id) => id.wallpaperId)
          .toList();
      final res = await wallpaperRepository.getFavouriteIds(wallpaperIds);
      favouritesIds.addAll(Set<int>.from(res.data["data"]));
      wallpapers.addAll(response.wallpaper);
      currentPage = nextPage;
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> addToFavourite(
    int wallpaperId,
    String imageUrl,
    String photographer,
  ) async {
    if (clickLoader) {
      return;
    }
    clickLoader = true;
    errorMessage = null;
    notifyListeners();
    try {
      await wallpaperRepository.addToFavourites(
        wallpaperId,
        imageUrl,
        photographer,
      );
      favouritesIds.add(wallpaperId);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      clickLoader = false;
      notifyListeners();
    }
  }

  Future<void> removeFromFavourites(int wallpaperId) async {
    if (clickLoader) {
      return;
    }
    clickLoader = true;
    errorMessage = null;
    notifyListeners();
    try {
      await wallpaperRepository.removeFromFavourites(wallpaperId);
      favouritesIds.remove(wallpaperId);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      clickLoader = false;
      notifyListeners();
    }
  }

  Future<void> downloadImage(String imageUrl) async {
    isDownloading = true;
    errorMessage = null;
    notifyListeners();
    try {
      wallpaperRepository.downloadImage(imageUrl);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }

  Future<void> searchWithDebounce(String query) async {
    print("QUERY IN VIEW MODEL :${query}");
    isLoading = true;
    errorMessage = null;
    retry = false;
    currentPage = 1;
    Query = query;
    print("SEARCH QUERY: $Query");
    notifyListeners();
    try {
      final response = await wallpaperRepository.getWallpapers(query, 1, limit);
      print("SEARCH RESPONSE: ${response.data}");
      final wallpaperResponse = response.data as WallpaperResponse;
      wallpapers = wallpaperResponse.wallpaper;
      final wallpaperId = wallpapers.map((id) => id.wallpaperId).toList();
      print("SENDING WALLPAPER ID :${wallpaperId}");
      final res = await wallpaperRepository.getFavouriteIds(wallpaperId);
      print("GET FAVOURITES ID RESPONSE : ${res.data}");
      favouritesIds = Set<int>.from(res.data["data"]);
      print("STORED FAVOURITES : $favouritesIds");
      print("CHECK ID : ${favouritesIds.contains(12377231)}");
      totalResults = wallpaperResponse.totalResults;
    } on AppException catch (e) {
      errorMessage = e.toString();
      retry = true;
    } catch (e) {
      errorMessage = e.toString();
      retry = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavourite(int wallpaperId) {
    if (favouritesIds.contains(wallpaperId)) {
      favouritesIds.remove(wallpaperId);
    } else {
      favouritesIds.add(wallpaperId);
    }
  }
}
