import 'package:flutter/material.dart';
import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/models/community.dart';
import 'package:wallverse/models/favourites.dart';
import 'package:wallverse/models/wallpaper.dart';
import 'package:wallverse/models/wallpaper_response.dart';
import 'package:wallverse/repositories/wallpaper_repository.dart';

class HomeViewmodel extends ChangeNotifier {
  final wallpaperRepository = WallpaperRepository();
  List<Wallpaper> wallpapers = [];
  List<Favourites> favouriteWallpapers = [];
  bool isLoading = false;
  bool clickLoader = false;
  String? errorMessage;
  bool retry = false;
  int limit = 16;
  int currentPage = 1;
  bool isLoadingMore = false;
  int totalResults = 0;
  String Query = "nature";

  Future<void> getWallpapers(String query) async {
    isLoading = true;
    errorMessage = null;
    retry = false;
    currentPage = 1;
    notifyListeners();

    try {
      final response = await wallpaperRepository.getWallpapers(
        Query = query,
        1,
        limit,
      );
      final wallpaperResponse = response.data as WallpaperResponse;
      wallpapers = wallpaperResponse.wallpaper;
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
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      clickLoader = false;
      notifyListeners();
    }
  }
}
