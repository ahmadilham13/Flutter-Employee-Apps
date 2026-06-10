import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:employeeapps/core/constants/api_endpoints.dart';
import 'package:employeeapps/core/network/dio_client.dart';
import '../../data/models/attendance_log_model.dart';

class AttendanceProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  List<AttendanceLogModel> _logs = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Pagination states
  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;

  List<AttendanceLogModel> get logs => _logs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;

  Future<bool> fetchLogs({int perPage = 10, bool isRefresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    if (isRefresh) {
      _logs = [];
    }
    notifyListeners();

    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.attendanceLogs,
        queryParameters: {
          'per_page': perPage,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final List<dynamic> dataList = responseData['data'] ?? [];
        
        _logs = dataList.map((item) => AttendanceLogModel.fromJson(item)).toList();
        
        // Parse pagination metadata if exists
        if (responseData['pagination'] != null) {
          final pag = responseData['pagination'];
          _currentPage = pag['current_page'] ?? 1;
          _lastPage = pag['last_page'] ?? 1;
          _total = pag['total'] ?? 0;
        }

        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        throw Exception('Failed to load logs. Server returned status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _isLoading = false;
      _errorMessage = e.response?.data?['message'] ?? e.response?.data?['error'] ?? 'Unable to retrieve attendance logs.';
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
