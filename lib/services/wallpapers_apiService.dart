import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/models/community_response.dart';
import 'package:wallverse/models/get_favourites_response.dart';
import 'package:wallverse/models/profile.dart';
import 'package:wallverse/models/wallpaper_response.dart';
import 'package:wallverse/responses/api_response.dart';
import 'package:wallverse/services/auth_api_service.dart';
import 'package:wallverse/services/secure_storage.dart';

class WallpapersApiservice {
  final baseUrl = "https://wallverse-backend-q00l.onrender.com";
  //https://wallverse-backend-q00l.onrender.com
  final authApiService = AuthApiService();
  final secureStorage = SecureStorage();

  Future<ApiResponse> getWallpapers(String query, int page, int perPage) async {
    var accessToken = await secureStorage.getAccessToken();
    if (accessToken == null) {
      throw UnauthorizedException("Unauthorised");
    }
    var response = await http.get(
      Uri.parse(
        "${baseUrl}/mobile/wallpaper?query=${query}&page=${page}&perPage=${perPage}",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 401) {
      accessToken = await authApiService.refreshToken();
      await secureStorage.saveAccessToken(accessToken);
      response = await http.get(
        Uri.parse(
          "${baseUrl}/mobile/wallpaper?query=${query}&page=${page}&perPage=${perPage}",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
    }
    final data = jsonDecode(response.body);
    final wallpaperResponse = WallpaperResponse.fromJson(data);
    return ApiResponse(
      statusCode: response.statusCode,
      data: wallpaperResponse,
    );
  }

  Future<ApiResponse> addToFavourites(
    int wallpaperId,
    String imageUrl,
    String photographer,
  ) async {
    var accessToken = await secureStorage.getAccessToken();
    var response = await http.post(
      Uri.parse("${baseUrl}/mobile/wallpaper/favourite"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "wallpaperId": wallpaperId,
        "imageUrl": imageUrl,
        "photographer": photographer,
      }),
    );
    if (response.statusCode == 401) {
      accessToken = await authApiService.refreshToken();
      await secureStorage.saveAccessToken(accessToken);
      response = await http.post(
        Uri.parse("${baseUrl}/mobile/wallpaper/favourite"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "wallpaperId": wallpaperId,
          "imageUrl": imageUrl,
          "photographer": photographer,
        }),
      );
    }
    return ApiResponse(
      statusCode: response.statusCode,
      data: jsonDecode(response.body),
    );
  }

  Future<ApiResponse> getFavouriteWallpapers(int page, int limit) async {
    var accessToken = await secureStorage.getAccessToken();
    if (accessToken == null) {
      throw UnauthorizedException("Unauthorised");
    }
    var response = await http.get(
      Uri.parse(
        "${baseUrl}/mobile/wallpaper/favourites?page=${page}&limit=${limit}",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 401) {
      accessToken = await authApiService.refreshToken();
      await secureStorage.saveAccessToken(accessToken);
      response = await http.get(
        Uri.parse(
          "${baseUrl}/mobile/wallpaper/favourites?page=${page}&limit=${limit}",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
    }
    final data = jsonDecode(response.body);
    final favouriteWallpapers = GetFavouritesResponse.fromJson(data);
    return ApiResponse(
      statusCode: response.statusCode,
      data: favouriteWallpapers,
    );
  }

  Future<ApiResponse> removeFromFavourites(int wallpaperId) async {
    var accessToken = await secureStorage.getAccessToken();
    if (accessToken == null) {
      throw UnauthorizedException("Unauthorised");
    }
    var response = await http.delete(
      Uri.parse("${baseUrl}/mobile/wallpaper/${wallpaperId}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 401) {
      accessToken = await authApiService.refreshToken();
      await secureStorage.saveAccessToken(accessToken);
      response = await http.delete(
        Uri.parse("${baseUrl}/mobile/wallpaper/${wallpaperId}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
    }
    return ApiResponse(
      statusCode: response.statusCode,
      data: jsonDecode(response.body),
    );
  }

  Future<ApiResponse> getCommunityWallpapers(int page, int limit) async {
    var accessToken = await secureStorage.getAccessToken();
    var res = await http.get(
      Uri.parse(
        "${baseUrl}/mobile/wallpaper/community?page=${page}&limit=${limit}",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (res.statusCode == 401) {
      accessToken = await authApiService.refreshToken();
      await secureStorage.saveAccessToken(accessToken);
      res = await http.get(
        Uri.parse(
          "${baseUrl}/mobile/wallpaper/community?page=${page}&limit=${limit}",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
    }
    final data = jsonDecode(res.body);
    final communityWallpapers = CommunityResponse.fromJson(data);
    return ApiResponse(statusCode: res.statusCode, data: communityWallpapers);
  }

  Future<ApiResponse> generateWallpaper(String prompt) async {
    var accessToken = await secureStorage.getAccessToken();
    var res = await http.post(
      Uri.parse("${baseUrl}/mobile/wallpaper/generate"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({"prompt": prompt}),
    );
    if (res.statusCode == 401) {
      accessToken = await authApiService.refreshToken();
      await secureStorage.saveAccessToken(accessToken);
      res = await http.post(
        Uri.parse("${baseUrl}/mobile/wallpaper/generate"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"prompt": prompt}),
      );
    }
    return ApiResponse(statusCode: res.statusCode, data: jsonDecode(res.body));
  }

  Future<ApiResponse> uploadWallpaper(File image, String title) async {
    var accessToken = await secureStorage.getAccessToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/mobile/wallpaper/upload'),
    );
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.fields["title"] = title;
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 401) {
      accessToken = await authApiService.refreshToken();
      request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/mobile/wallpaper/upload'),
      );
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.fields["title"] = title;
      streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);
    }
    return ApiResponse(
      statusCode: response.statusCode,
      data: jsonDecode(response.body),
    );
  }

  Future<ApiResponse> getUserProfile() async {
    var accessToken = await secureStorage.getAccessToken();
    var res = await http.get(
      Uri.parse("${baseUrl}/mobile/wallpaper/profile"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (res.statusCode == 401) {
      accessToken = await authApiService.refreshToken();
      await secureStorage.saveAccessToken(accessToken);
      res = await http.get(
        Uri.parse("${baseUrl}/mobile/wallpaper/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
    }
    return ApiResponse(
      statusCode: res.statusCode,
      data: Profile.fromJson(jsonDecode(res.body)),
    );
  }

  Future<ApiResponse> deletePost(int postId) async {
    var accessToken = await secureStorage.getAccessToken();
    var res = await http.delete(
      Uri.parse("${baseUrl}/mobile/wallpaper/post/${postId}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (res.statusCode == 401) {
      accessToken = await authApiService.refreshToken();
      await secureStorage.saveAccessToken(accessToken);
      res = await http.delete(
        Uri.parse("${baseUrl}/mobile/wallpaper/post/${postId}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
    }
    return ApiResponse(
      statusCode: res.statusCode,
      data: (jsonDecode(res.body)),
    );
  }

  Future<ApiResponse> likePost(int postId) async {
    var accessToken = await secureStorage.getAccessToken();
    var res = await http.post(
      Uri.parse("${baseUrl}/mobile/wallpaper/like/${postId}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (res.statusCode == 401) {
      accessToken = await authApiService.refreshToken();
      await secureStorage.saveAccessToken(accessToken);
      res = await http.post(
        Uri.parse("${baseUrl}/mobile/wallpaper/like/${postId}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
    }
    return ApiResponse(
      statusCode: res.statusCode,
      data: (jsonDecode(res.body)),
    );
  }

  Future<ApiResponse> unlikePost(int postId) async {
    var accessToken = await secureStorage.getAccessToken();
    var res = await http.post(
      Uri.parse("${baseUrl}/mobile/wallpaper/unlike/${postId}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (res.statusCode == 401) {
      accessToken = await authApiService.refreshToken();
      await secureStorage.saveAccessToken(accessToken);
      res = await http.post(
        Uri.parse("${baseUrl}/mobile/wallpaper/unlike/${postId}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
    }
    return ApiResponse(
      statusCode: res.statusCode,
      data: (jsonDecode(res.body)),
    );
  }
}
