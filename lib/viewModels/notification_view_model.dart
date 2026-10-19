import 'package:flutter/material.dart';
import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/models/notification_list.dart';
import 'package:wallverse/models/notifications.dart';
import 'package:wallverse/repositories/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  final notificationRepository = NotificationRepository();
  bool isLoading = false;
  bool isLoadingMore = false;
  String? errorMessage;
  List<NotificationList> notificationList = [];
  int currentPage = 1;
  int hasMoreNotification = 0;
  int limit = 10;

  Future<void> getNotifications() async {
    isLoading = true;
    errorMessage = null;
    currentPage = 1;
    notifyListeners();
    try {
      final res = await notificationRepository.getNotification(
        currentPage,
        limit,
      );
      final notification = res.data as Notifications;
      notificationList = notification.notificationList;
      hasMoreNotification = notification.totalNotifications;
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreNotifications() async {
    if (isLoadingMore || isLoading) {
      return;
    }
    if (notificationList.length >= hasMoreNotification) {
      return;
    }
    int nextPage = currentPage + 1;
    isLoadingMore = true;
    errorMessage = null;
    notifyListeners();
    try {
      final moreNotifications = await notificationRepository.getNotification(
        nextPage,
        limit,
      );
      final res = moreNotifications.data as Notifications;
      if (res.notificationList.isEmpty) {
        return;
      }
      notificationList.addAll(res.notificationList);
      currentPage = nextPage;
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
