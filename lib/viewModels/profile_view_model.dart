import 'package:flutter/material.dart';
import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/models/profile.dart';
import 'package:wallverse/repositories/auth_repository.dart';
import 'package:wallverse/repositories/wallpaper_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final wallpaperRepository = WallpaperRepository();
  final authRepository = AuthRepository();
  bool isLoading = false;
  bool clickLoader = false;
  String? errorMessage;
  Profile? profile;

  Future<void> getUserProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await wallpaperRepository.getUserProfile();
      profile = res.data;
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePost(int postId) async {
    clickLoader = true;
    errorMessage = null;
    notifyListeners();
    try {
      await wallpaperRepository.deletePost(postId);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      clickLoader = false;
      notifyListeners();
    }
  }

  void deletePostLocally(int postId) {
    profile?.userUploads.removeWhere((item) => item.id == postId);
    notifyListeners();
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();
    try {
      await authRepository.logout();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
