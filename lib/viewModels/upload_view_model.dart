import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/repositories/wallpaper_repository.dart';

class UploadViewModel extends ChangeNotifier {
  final wallpaperRepository = WallpaperRepository();
  bool isLoading = false;
  String? errorMessage;

  Future<void> uploadWallpaper(File image, String title) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await wallpaperRepository.uploadWallpaper(image, title);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
