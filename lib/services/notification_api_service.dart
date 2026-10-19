import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wallverse/models/notifications.dart';
import 'package:wallverse/responses/api_response.dart';
import 'package:wallverse/services/auth_api_service.dart';
import 'package:wallverse/services/secure_storage.dart';

class NotificationApiService {
  final String baseUrl = "http://172.20.10.2:3001";
  final authApiService = AuthApiService();
  final secureStorage = SecureStorage();

  Future<ApiResponse> getNotifications(int page, int limit) async {
    var accessToken = await secureStorage.getAccessToken();
    var response = await http.get(
      Uri.parse(
        "${baseUrl}/mobile/wallpaper/notification?page=${page}&limit=${limit}",
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
          "${baseUrl}/mobile/wallpaper/notification?page=${page}&limit=${limit}",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
    }
    print("NOTIFICATION API RESPONSE: ${response.body}");
    final data = jsonDecode(response.body);
    final notification = Notifications.fromJson(data);
    return ApiResponse(statusCode: response.statusCode, data: notification);
  }
}
