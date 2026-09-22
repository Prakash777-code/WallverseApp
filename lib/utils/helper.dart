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
}
