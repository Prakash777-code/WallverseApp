import 'package:flutter/material.dart';
import 'package:wallverse/exceptions/app_exceptions.dart';
import 'package:wallverse/repositories/auth_repository.dart';

class AuthViewmodel extends ChangeNotifier {
  final authRepository = AuthRepository();
  bool isLoading = false;
  String? errorMessage;
  bool isLoggedIn = false;

  Future<void> register(String name, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await authRepository.register(name, email, password);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await authRepository.login(email, password);
      isLoggedIn = true;
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthentication() async {
    isLoggedIn = await authRepository.isLoggedIn();
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
