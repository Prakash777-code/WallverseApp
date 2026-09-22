import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/responses/api_response.dart';
import 'package:wallverse/services/auth_api_service.dart';
import 'package:wallverse/services/secure_storage.dart';
import 'package:wallverse/utils/helper.dart';

class AuthRepository {
  final authApiService = AuthApiService();
  final helper = Helper();
  final secureStorage = SecureStorage();

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
    final response = await authApiService.loginUser(email, password);
    if (response.statusCode == 201) {
      print("Saving tokens");
      await secureStorage.saveTokens(
        response.data["accessToken"],
        response.data["refreshToken"],
      );
      print("Tokens saved");
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
}
