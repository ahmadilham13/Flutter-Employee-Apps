import 'package:employeeapps/features/attendance/data/models/attendance_log_model.dart';

class WorkingHoursSummary {
  final String totalWorkMinutes;
  final int totalOvertimeMinutes;
  final String totalDeficitMinutes;

  WorkingHoursSummary({
    required this.totalWorkMinutes,
    required this.totalOvertimeMinutes,
    required this.totalDeficitMinutes,
  });

  factory WorkingHoursSummary.fromJson(Map<String, dynamic> json) {
    return WorkingHoursSummary(
      totalWorkMinutes: json['total_work_minutes'].toString(),
      totalOvertimeMinutes: int.tryParse(json['total_overtime_minutes'].toString()) ?? 0,
      totalDeficitMinutes: json['total_deficit_minutes'].toString(),
    );
  }
}

class WorkingHoursData {
  final String month;
  final WorkingHoursSummary monthlySummary;
  final WorkingHoursSummary weeklySummary;
  final List<AttendanceLogModel> attendances;

  WorkingHoursData({
    required this.month,
    required this.monthlySummary,
    required this.weeklySummary,
    required this.attendances,
  });

  factory WorkingHoursData.fromJson(Map<String, dynamic> json) {
    return WorkingHoursData(
      month: json['month'] ?? '',
      monthlySummary: WorkingHoursSummary.fromJson(json['monthly_summary'] ?? {}),
      weeklySummary: WorkingHoursSummary.fromJson(json['weekly_summary'] ?? {}),
      attendances: (json['attendances'] as List?)?.map((e) => AttendanceLogModel.fromJson(e)).toList() ?? [],
    );
  }
}

class WorkingHoursModel {
  final String status;
  final WorkingHoursData? data;

  WorkingHoursModel({
    required this.status,
    this.data,
  });

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      status: json['status'] ?? '',
      data: json['data'] != null ? WorkingHoursData.fromJson(json['data']) : null,
    );
  }
}
