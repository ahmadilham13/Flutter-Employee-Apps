class ApiEndpoints {
  // Replace with your local backend URL or production server IP/domain.
  // Note: 'http://10.0.2.2:8000' is the standard loopback IP for Android Emulators
  // pointing to the host's localhost:8000. Use 'http://localhost:8000' for web/desktop.
  static const String baseUrl = 'http://192.168.8.107:8000';

  static const String login = '/api/v1/login';
  static const String logout = '/api/v1/logout';
  static const String userProfile = '/api/v1/user';
  static const String attendanceLogs = '/api/v1/attendance/logs';
}
