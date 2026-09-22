import 'package:flutter/material.dart';
import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/models/get_favourites.dart';
import 'package:wallverse/models/get_favourites_response.dart';
import 'package:wallverse/repositories/wallpaper_repository.dart';

class FavouritesViewModel extends ChangeNotifier {
  final wallpaperRepository = WallpaperRepository();
  bool isLoading = false;
  bool isLoadingMore = false;
  bool clickLoader = false;
  String? errorMessage = null;
  int currentPage = 1;
  int limit = 10;
  int totalFavourites = 0;
  List<GetFavourites> favouriteWallpapers = [];

  Future<void> getFavouriteWallpaper() async {
    isLoading = true;
    errorMessage = null;
    currentPage = 1;
    notifyListeners();
    try {
      final res = await wallpaperRepository.getFavouriteWallpapers(1, limit);
      final wallpaperResponse = res.data as GetFavouritesResponse;
      favouriteWallpapers = wallpaperResponse.favourites;
      totalFavourites = wallpaperResponse.totalFavourites;
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreFavouriteWallpapers() async {
    if (isLoading) {
      return;
    }
    if (favouriteWallpapers.length >= totalFavourites) {
      return;
    }
    final nextPage = currentPage + 1;
    isLoadingMore = true;
    errorMessage = null;
    notifyListeners();
    try {
      final moreWallpapers = await wallpaperRepository.getFavouriteWallpapers(
        nextPage,
        limit,
      );
      final wallpaperResponse = moreWallpapers.data as GetFavouritesResponse;
      favouriteWallpapers.addAll(wallpaperResponse.favourites);
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

  Future<void> removeFromFavourites(int wallpaperId) async {
    if (clickLoader) {
      return;
    }
    clickLoader = true;
    errorMessage = null;
    notifyListeners();
    try {
      await wallpaperRepository.removeFromFavourites(wallpaperId);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      clickLoader = false;
      notifyListeners();
    }
  }

  void removeWallpaperLocally(int wallpaperId) {
    favouriteWallpapers.removeWhere(
      (item) => item.wallpaperId == wallpaperId.toString(),
    );
    notifyListeners();
  }
}
