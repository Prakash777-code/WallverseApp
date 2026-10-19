import 'package:flutter/material.dart';
import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/repositories/wallpaper_repository.dart';

class FullScreenViewModel extends ChangeNotifier {
  final wallpaperRepository = WallpaperRepository();
  bool isDownloading = false;
  String? errorMessage;

  Future<void> downloadImage(String imageUrl) async {
    isDownloading = true;
    errorMessage = null;
    notifyListeners();
    try {
      wallpaperRepository.downloadImage(imageUrl);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }
}
