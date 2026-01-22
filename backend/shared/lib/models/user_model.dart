class UserModel {
  final String id;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// From database row
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      isVerified: map['is_verified'] as bool,
      isActive: map['is_active'] as bool,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// To JSON (for API responses)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'isVerified': isVerified,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// To JSON without sensitive data
  Map<String, dynamic> toPublicJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
    };
  }

  /// Full name
  String get fullName => '$firstName $lastName';
}
