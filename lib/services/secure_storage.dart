import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await secureStorage.write(key: "accessToken", value: accessToken);
    await secureStorage.write(key: "refreshToken", value: refreshToken);
  }

  Future<void> saveAccessToken(String accessToken) async {
    await secureStorage.write(
      key: "accessToken",
      value: accessToken,
    );
  }


  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: "accessToken");
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: "refreshToken");
  }

  Future<void> clearTokens() async {
    await secureStorage.delete(key: "accessToken");
    await secureStorage.delete(key: "refreshToken");
  }
}
