class ContractModel {
  final int id;
  final String name;
  final String workType;
  final String checkinStart;
  final String checkinEnd;
  final String checkoutTime;

  ContractModel({
    required this.id,
    required this.name,
    required this.workType,
    required this.checkinStart,
    required this.checkinEnd,
    required this.checkoutTime,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      workType: json['work_type'] ?? '',
      checkinStart: json['checkin_start'] ?? '',
      checkinEnd: json['checkin_end'] ?? '',
      checkoutTime: json['checkout_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'work_type': workType,
      'checkin_start': checkinStart,
      'checkin_end': checkinEnd,
      'checkout_time': checkoutTime,
    };
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String? position;
  final String? avatarUrl;
  final ContractModel? contract;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.position,
    this.avatarUrl,
    this.contract,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Safely parse user from response, support nesting under "data" or root object
    final userData = json['data'] ?? json;
    
    // Parse roles list if present, fallback to role
    String? resolvedRole;
    if (userData['roles'] is List) {
      final List rolesList = userData['roles'];
      if (rolesList.isNotEmpty) {
        resolvedRole = rolesList.first.toString();
      }
    }
    resolvedRole ??= userData['role'] ?? 'Staff';

    return UserModel(
      id: userData['id'] ?? 0,
      name: userData['name'] ?? 'Employee',
      email: userData['email'] ?? '',
      role: resolvedRole,
      position: userData['position'] ?? 'Staff',
      avatarUrl: userData['avatar_url'] ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=256&auto=format&fit=crop',
      contract: userData['contract'] != null 
          ? ContractModel.fromJson(userData['contract']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'position': position,
      'avatar_url': avatarUrl,
      'contract': contract?.toJson(),
    };
  }
}
