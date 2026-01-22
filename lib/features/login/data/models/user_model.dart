class UserModel {
  final String id;
  final String? name;
  final String mobile;
  final String role;
  final String organizationId;

  UserModel({
    required this.id,
    this.name,
    required this.mobile,
    required this.role,
    required this.organizationId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'],
      mobile: json['mobile'] ?? '',
      role: json['role'] ?? 'USER',
      organizationId: json['organizationId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'mobile': mobile,
      'role': role,
      'organizationId': organizationId,
    };
  }
}
