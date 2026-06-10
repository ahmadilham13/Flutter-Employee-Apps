class UserModel {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String? position;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.position,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Safely parse user from response, support nesting under "data" or root object
    final userData = json['data'] ?? json;
    
    return UserModel(
      id: userData['id'] ?? 0,
      name: userData['name'] ?? 'Employee',
      email: userData['email'] ?? '',
      role: userData['role'] ?? 'Staff',
      position: userData['position'] ?? 'Developer',
      avatarUrl: userData['avatar_url'] ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=256&auto=format&fit=crop',
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
    };
  }
}
