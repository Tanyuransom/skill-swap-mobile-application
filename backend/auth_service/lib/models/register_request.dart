class RegisterRequest {
  final String email;
  final String password;
  final String role;
  final String firstName;
  final String lastName;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  /// Validate request
  List<String> validate() {
    final errors = <String>[];

    if (email.isEmpty || !_isValidEmail(email)) {
      errors.add('Invalid email address');
    }

    if (password.length < 8) {
      errors.add('Password must be at least 8 characters');
    }

    if (!['student', 'tutor'].contains(role)) {
      errors.add('Role must be either student or tutor');
    }

    if (firstName.isEmpty) {
      errors.add('First name is required');
    }

    if (lastName.isEmpty) {
      errors.add('Last name is required');
    }

    return errors;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
