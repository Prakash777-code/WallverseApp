import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/responses/api_response.dart';
import 'package:wallverse/services/auth_api_service.dart';
import 'package:wallverse/services/secure_storage.dart';
import 'package:wallverse/utils/helper.dart';

class AuthRepository {
  final authApiService = AuthApiService();
  final helper = Helper();
  final secureStorage = SecureStorage();
  bool passwordChangeRequired = false;

  Future<ApiResponse> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await authApiService.registerUser(name, email, password);
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }

  Future<ApiResponse> login(String email, String password) async {
    print("REACHED LOGIN RESPOSITORY");
    final response = await authApiService.loginUser(email, password);
    helper.handleRequest(response);
    if (response.statusCode == 201 &&
        response.data["passwordChangeRequired"] == true) {
      passwordChangeRequired = true;
      print(passwordChangeRequired);
      await secureStorage.saveRefreshToken(response.data["refreshToken"]);
      print("SAVED REFRESH TOKEN");
      print("REFRESH TOKEN ${response.data["refreshToken"]}");
    } else {
      await secureStorage.saveTokens(
        response.data["accessToken"],
        response.data["refreshToken"],
      );
    }
    return response;
  }

  Future<bool> isLoggedIn() async {
    final acessToken = await secureStorage.getAccessToken();
    final refreshToken = await secureStorage.getRefreshToken();
    if (acessToken == null && refreshToken == null) {
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    await secureStorage.clearTokens();
  }

  Future<ApiResponse> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await authApiService.updatePassword(
        currentPassword,
        newPassword,
      );
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }
}
