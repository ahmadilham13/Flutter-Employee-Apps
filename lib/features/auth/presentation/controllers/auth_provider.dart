import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:employeeapps/core/constants/api_endpoints.dart';
import 'package:employeeapps/core/network/dio_client.dart';
import 'package:employeeapps/core/utils/local_storage.dart';
import 'package:employeeapps/features/auth/data/models/user_model.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();
  
  AuthStatus _status = AuthStatus.initial;
  UserModel? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == AuthStatus.authenticating;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    // Register the unauthorized (401) callback to trigger logout
    DioClient.onUnauthorized = () {
      _handleUnauthorized();
    };
  }

  // Check auth session on app start
  Future<void> checkAuth() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      if (LocalStorage.hasToken()) {
        final token = LocalStorage.getToken();
        if (token != null && token.isNotEmpty) {
          // Fetch user profile from GET /api/v1/user
          final response = await _dioClient.dio.get(ApiEndpoints.userProfile);
          
          if (response.statusCode == 200) {
            _currentUser = UserModel.fromJson(response.data);
            _status = AuthStatus.authenticated;
            _errorMessage = null;
          } else {
            await _clearSession();
          }
        } else {
          await _clearSession();
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      // If server or network error, let's see if we have token
      // We might want to keep the session authenticated if offline,
      // but for standard auth, check response: if it's 401, clear it.
      if (e is DioException && e.response?.statusCode == 401) {
        await _clearSession();
      } else {
        // Other network errors (e.g. timeout), let's keep status unauthenticated or offline.
        // For simplicity, we fallback to unauthenticated but keep token
        _status = AuthStatus.unauthenticated;
      }
    }
    notifyListeners();
  }

  // Login POST /api/v1/login
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        // Adjust based on the actual payload schema.
        // Usually: { "token": "...", "user": { ... } } or { "data": { "token": "...", "user": { ... } } }
        final String? token = responseData['token'] ?? responseData['data']?['token'];
        final dynamic userJson = responseData['user'] ?? responseData['data']?['user'] ?? responseData['data'];

        if (token != null) {
          await LocalStorage.saveToken(token);
          _currentUser = UserModel.fromJson(userJson);
          _status = AuthStatus.authenticated;
          _errorMessage = null;
          notifyListeners();
          return true;
        } else {
          throw Exception('Token not found in response payload.');
        }
      } else {
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.response?.data?['message'] ?? e.response?.data?['error'] ?? 'Login failed. Please check credentials.';
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Logout POST /api/v1/logout
  Future<void> logout() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      if (LocalStorage.hasToken()) {
        // Send request to POST /api/v1/logout
        await _dioClient.dio.post(ApiEndpoints.logout);
      }
    } catch (e) {
      // Ignore network errors on logout to ensure user session is cleared locally
      debugPrint('Logout api request error: $e');
    } finally {
      await _clearSession();
      notifyListeners();
    }
  }

  // Internal helper to clear stored state on logout or expired session
  Future<void> _clearSession() async {
    await LocalStorage.removeToken();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
  }

  // Handle automatic 401 logout
  void _handleUnauthorized() {
    _clearSession().then((_) {
      notifyListeners();
    });
  }
}
