import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/responses/api_response.dart';
import 'package:wallverse/services/notification_api_service.dart';
import 'package:wallverse/utils/helper.dart';

class NotificationRepository {
  final helper = Helper();
  final notificationApiService = NotificationApiService();

  Future<ApiResponse> getNotification(int page, int limit) async {
    try {
      final response = await notificationApiService.getNotifications(
        page,
        limit,
      );
      helper.handleRequest(response);
      return response;
    } on AppException {
      rethrow;
    }
  }
}
