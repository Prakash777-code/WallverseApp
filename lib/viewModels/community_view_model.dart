import 'package:flutter/material.dart';
import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/models/community.dart';
import 'package:wallverse/models/community_response.dart';
import 'package:wallverse/repositories/wallpaper_repository.dart';

class CommunityViewModel extends ChangeNotifier {
  final wallpaperRepository = WallpaperRepository();
  bool isLoading = false;
  bool isLoadingMore = false;
  bool clickLoader = false;
  bool isLiking = false;
  String? errorMessage;
  List<Community> communityWallpapers = [];
  int currentPage = 1;
  int limit = 10;
  int totaPosts = 0;

  Future<void> getCommunityWallpapers() async {
    currentPage = 1;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await wallpaperRepository.getCommunityWallpapers(1, limit);
      final communityResponse = res.data as CommunityResponse;
      communityWallpapers = communityResponse.communityWallpapers;
      totaPosts = communityResponse.totalPosts;
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (isLoading) {
      return;
    }
    if (communityWallpapers.length >= totaPosts) {
      return;
    }
    int nextPage = currentPage + 1;
    isLoadingMore = true;
    errorMessage = null;
    notifyListeners();
    try {
      final morePosts = await wallpaperRepository.getCommunityWallpapers(
        nextPage,
        limit,
      );
      final communityResponse = morePosts.data as CommunityResponse;
      communityWallpapers.addAll(communityResponse.communityWallpapers);
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

  Future<void> removeFromFavourites(int wallpaperId) async {
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

  Future<void> likePost(int postId) async {
    isLiking = true;
    errorMessage = null;
    notifyListeners();
    try {
      await wallpaperRepository.likePost(postId);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLiking = false;
      notifyListeners();
    }
  }

  Future<void> unlikePost(int postId) async {
    isLiking = true;
    errorMessage = null;
    notifyListeners();
    try {
      await wallpaperRepository.unlikePost(postId);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLiking = false;
      notifyListeners();
    }
  }
}
