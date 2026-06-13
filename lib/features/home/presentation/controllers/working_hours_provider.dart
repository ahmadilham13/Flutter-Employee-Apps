import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:employeeapps/core/constants/api_endpoints.dart';
import 'package:employeeapps/core/network/dio_client.dart';
import '../../data/models/working_hours_model.dart';
import 'package:employeeapps/features/attendance/data/models/attendance_log_model.dart';

class WorkingHoursProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  WorkingHoursData? _workingHoursData;
  List<AttendanceLogModel> _attendances = [];
  bool _isLoading = false;
  String? _errorMessage;

  WorkingHoursData? get workingHoursData => _workingHoursData;
  List<AttendanceLogModel> get attendances => _attendances;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> fetchWorkingHours({String? month, int page = 1, int perPage = 10}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'per_page': perPage,
      };
      if (month != null) {
        queryParams['month'] = month;
      }

      final response = await _dioClient.dio.get(
        ApiEndpoints.workingHours,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final model = WorkingHoursModel.fromJson(response.data);
        _workingHoursData = model.data;
        _attendances = model.data?.attendances ?? [];
        
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        throw Exception('Failed to load working hours.');
      }
    } on DioException catch (e) {
      _isLoading = false;
      _errorMessage = e.response?.data?['message'] ?? e.response?.data?['error'] ?? 'Unable to retrieve working hours.';
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
