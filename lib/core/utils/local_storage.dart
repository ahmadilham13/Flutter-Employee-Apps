import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _tokenKey = 'auth_token';
  static SharedPreferences? _prefs;

  // Initialize shared preferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save authentication token
  static Future<bool> saveToken(String token) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(_tokenKey, token);
  }

  // Retrieve authentication token
  static String? getToken() {
    if (_prefs == null) {
      // If not initialized, user should call init() first or it'll fetch synchronously if initialized
      throw Exception('SharedPreferences not initialized. Call LocalStorage.init() first.');
    }
    return _prefs!.getString(_tokenKey);
  }

  // Remove authentication token (Logout)
  static Future<bool> removeToken() async {
    if (_prefs == null) await init();
    return await _prefs!.remove(_tokenKey);
  }

  // Check if token exists
  static bool hasToken() {
    if (_prefs == null) return false;
    return _prefs!.containsKey(_tokenKey) && _prefs!.getString(_tokenKey) != null;
  }
}
