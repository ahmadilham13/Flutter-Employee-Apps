import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:employeeapps/core/constants/api_endpoints.dart';
import 'package:employeeapps/core/network/dio_client.dart';

class CheckInOutProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _errorMessage = 'Location services are disabled.';
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _errorMessage = 'Location permissions are denied';
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _errorMessage = 'Location permissions are permanently denied, we cannot request permissions.';
      return null;
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<bool> checkIn() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _getCurrentLocation();
      if (position == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final response = await _dioClient.dio.post(
        ApiEndpoints.checkIn,
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Check-in failed');
      }
    } on DioException catch (e) {
      _isLoading = false;
      _errorMessage = e.response?.data?['message'] ?? 'Check-in failed.';
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkOut({String? earlyLeavingReason}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _getCurrentLocation();
      if (position == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> data = {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };

      if (earlyLeavingReason != null && earlyLeavingReason.isNotEmpty) {
        data['early_leaving_reason'] = earlyLeavingReason;
      }

      final response = await _dioClient.dio.post(
        ApiEndpoints.checkOut,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Check-out failed');
      }
    } on DioException catch (e) {
      _isLoading = false;
      _errorMessage = e.response?.data?['message'] ?? 'Check-out failed.';
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
