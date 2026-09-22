import 'dart:io';

import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/responses/api_response.dart';
import 'package:wallverse/services/secure_storage.dart';
import 'package:wallverse/services/wallpapers_apiService.dart';
import 'package:wallverse/utils/helper.dart';

class WallpaperRepository {
  final wallpaperApiService = WallpapersApiservice();
  final helper = Helper();
  final secureStorage = SecureStorage();

  Future<ApiResponse> getWallpapers(String query, int page, int perPage) async {
    try {
      final response = await wallpaperApiService.getWallpapers(
        query,
        page,
        perPage,
      );
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }

  Future<ApiResponse> addToFavourites(
    int wallpaperId,
    String imageUrl,
    String photographer,
  ) async {
    try {
      final response = await wallpaperApiService.addToFavourites(
        wallpaperId,
        imageUrl,
        photographer,
      );
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }

  Future<ApiResponse> getFavouriteWallpapers(int page, int limit) async {
    try {
      final response = await wallpaperApiService.getFavouriteWallpapers(
        page,
        limit,
      );
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }

  Future<ApiResponse> removeFromFavourites(int wallpaperId) async {
    try {
      final response = await wallpaperApiService.removeFromFavourites(
        wallpaperId,
      );
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }

  Future<ApiResponse> getCommunityWallpapers(int page, int limit) async {
    try {
      final response = await wallpaperApiService.getCommunityWallpapers(
        page,
        limit,
      );
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }

  Future<ApiResponse> generateWallpaper(String prompt) async {
    try {
      final response = await wallpaperApiService.generateWallpaper(prompt);
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }

  Future<ApiResponse> uploadWallpaper(File image, String title) async {
    try {
      final response = await wallpaperApiService.uploadWallpaper(image, title);
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }

  Future<ApiResponse> getUserProfile() async {
    try {
      final response = await wallpaperApiService.getUserProfile();
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }

  Future<ApiResponse> deletePost(int postId) async {
    try {
      final response = await wallpaperApiService.deletePost(postId);
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }

  Future<ApiResponse> likePost(int postId) async {
    try {
      final response = await wallpaperApiService.likePost(postId);
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }

  Future<ApiResponse> unlikePost(int postId) async {
    try {
      final response = await wallpaperApiService.unlikePost(postId);
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }
}
