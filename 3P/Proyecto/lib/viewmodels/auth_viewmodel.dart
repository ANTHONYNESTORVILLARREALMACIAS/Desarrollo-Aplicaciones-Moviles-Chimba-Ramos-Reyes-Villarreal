import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/web_storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  Future<void> login(String username, String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulación de login - en producción conectarías con tu backend
      await Future.delayed(const Duration(seconds: 1));
      
      if (username.isEmpty || email.isEmpty) {
        throw Exception('Username y email son requeridos');
      }

      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        email: email,
        createdAt: DateTime.now(),
      );

      // Guardar usuario en almacenamiento Web
      await WebStorageService.saveUser(_currentUser!);
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await WebStorageService.clearUser();
    notifyListeners();
  }

  Future<void> checkSavedUser() async {
    _currentUser = await WebStorageService.getSavedUser();
    notifyListeners();
  }
}
