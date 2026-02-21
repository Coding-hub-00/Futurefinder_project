import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _user;
  bool _isLoading = false;
  String _errorMessage = '';
  static const storage = FlutterSecureStorage();

  String? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String get errorMessage => _errorMessage;

  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      _user = email;
      
      // Save login activity
      await storage.write(key: 'last_login', value: DateTime.now().toIso8601String());
      await storage.write(key: 'login_email', value: email);
      await storage.write(key: 'login_method', value: 'Email/Password');
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<Map<String, String?>> getLoginActivity() async {
    return {
      'email': await storage.read(key: 'login_email'),
      'last_login': await storage.read(key: 'last_login'),
      'method': await storage.read(key: 'login_method'),
    };
  }

  Future<bool> registerWithEmail(String username, String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await ApiService.register(username, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await ApiService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> checkAuthState() async {
    final token = await storage.read(key: 'token');
    if (token != null) {
      try {
        // Quick timeout for offline mode
        final profile = await ApiService.getProfile().timeout(Duration(seconds: 3));
        _user = profile.email;
        notifyListeners();
      } catch (e) {
        // If offline or error, check if it's offline token
        if (token == 'offline_token') {
          _user = 'offline_user@demo.com';
          notifyListeners();
        } else {
          await storage.delete(key: 'token');
        }
      }
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}