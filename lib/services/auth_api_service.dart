import 'dart:convert';

import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/responses/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:wallverse/services/secure_storage.dart';

class AuthApiService {
  final baseUrl = "https://wallverse-backend-q00l.onrender.com";
  //http://172.20.10.2:3001
  final secureStorage = SecureStorage();

  Future<ApiResponse> registerUser(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("${baseUrl}/mobile/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
    return ApiResponse(statusCode: response.statusCode, data: response);
  }

  Future<ApiResponse> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("${baseUrl}/mobile/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return ApiResponse(
      statusCode: response.statusCode,
      data: jsonDecode(response.body),
    );
  }

  Future<String> refreshToken() async {
    final refreshToken = await secureStorage.getRefreshToken();
    if (refreshToken == null) {
      throw UnauthorizedException("Session expired. Please login again.");
    }
    final response = await http.post(
      Uri.parse("${baseUrl}/mobile/auth/refresh"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return data["accessToken"];
    }
    throw UnauthorizedException(
      data["message"] ?? "Session expired. Please login again.",
    );
  }
}
