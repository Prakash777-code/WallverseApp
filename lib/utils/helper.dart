import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/responses/api_response.dart';

class Helper {
  void handleRequest(ApiResponse response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    final body = response.data;

    if (response.statusCode == 400) {
      throw BadRequestException(body["message"]);
    }

    if (response.statusCode == 401) {
      throw UnauthorizedException(body["message"]);
    }

    if (response.statusCode == 404) {
      throw NotFoundException(body["message"]);
    }

    if (response.statusCode == 409) {
      throw ConflictException(body["message"]);
    }

    if (response.statusCode == 500) {
      throw ServerException(body["message"]);
    }

    if (response.statusCode == 429) {
      throw ThrottleException("Too many requests, please try again later");
    }

    throw AppException(body["message"]);
  }

  String checkPassword(String password) {
    switch (password) {
      case _ when password.length < 8:
        return "Password must be at least 8 characters";

      case _ when RegExp(r'[A-Z]').allMatches(password).length < 2:
        return "Password must contain 2 uppercase characters";

      case _ when RegExp(r'[a-z]').allMatches(password).length < 2:
        return "Password must contain 2 lowercase characters";

      case _ when RegExp(r'[0-9]').allMatches(password).length < 2:
        return "Password must contain 2 numbers";

      case _ when RegExp(r'[!@#$%^&*]').allMatches(password).length < 2:
        return "Password must contain 2 special character";

      default:
        return "Strong password";
    }
  }
}
