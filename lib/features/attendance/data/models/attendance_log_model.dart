class AttendanceLogModel {
  final int id;
  final String date;
  final String? checkinTime;
  final String? checkoutTime;
  final double? checkinLatitude;
  final double? checkinLongitude;
  final double? checkoutLatitude;
  final double? checkoutLongitude;
  final String? checkinStatus;
  final String? checkoutStatus;
  final String? earlyLeavingReason;

  AttendanceLogModel({
    required this.id,
    required this.date,
    this.checkinTime,
    this.checkoutTime,
    this.checkinLatitude,
    this.checkinLongitude,
    this.checkoutLatitude,
    this.checkoutLongitude,
    this.checkinStatus,
    this.checkoutStatus,
    this.earlyLeavingReason,
  });

  factory AttendanceLogModel.fromJson(Map<String, dynamic> json) {
    return AttendanceLogModel(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      checkinTime: json['checkin_time'],
      checkoutTime: json['checkout_time'],
      checkinLatitude: json['checkin_latitude'] != null ? double.tryParse(json['checkin_latitude'].toString()) : null,
      checkinLongitude: json['checkin_longitude'] != null ? double.tryParse(json['checkin_longitude'].toString()) : null,
      checkoutLatitude: json['checkout_latitude'] != null ? double.tryParse(json['checkout_latitude'].toString()) : null,
      checkoutLongitude: json['checkout_longitude'] != null ? double.tryParse(json['checkout_longitude'].toString()) : null,
      checkinStatus: json['checkin_status'],
      checkoutStatus: json['checkout_status'],
      earlyLeavingReason: json['early_leaving_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'checkin_time': checkinTime,
      'checkout_time': checkoutTime,
      'checkin_latitude': checkinLatitude,
      'checkin_longitude': checkinLongitude,
      'checkout_latitude': checkoutLatitude,
      'checkout_longitude': checkoutLongitude,
      'checkin_status': checkinStatus,
      'checkout_status': checkoutStatus,
      'early_leaving_reason': earlyLeavingReason,
    };
  }
}
