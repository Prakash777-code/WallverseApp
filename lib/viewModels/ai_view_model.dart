import 'package:flutter/material.dart';
import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/repositories/wallpaper_repository.dart';

class AiViewModel extends ChangeNotifier {
  final wallpaperRepository = WallpaperRepository();
  bool isLoading = false;
  String? errorMessage;

  Future<String> generateWallpaper(String prompt) async {
    if (prompt.isEmpty) {
      errorMessage = "Prompt is required to generate wallpaper";
      return "";
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await wallpaperRepository.generateWallpaper(prompt);
      return res.data['imageUrl'];
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return errorMessage = "Failed to generate wallpaper";
  }

  Future<void> addToFavourite(int wallpaperId, String imageUrl, String photographer) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try{
      await wallpaperRepository.addToFavourites(wallpaperId, imageUrl, photographer);
    } on AppException catch(e){
      errorMessage = e.toString();
    } catch(e){
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
