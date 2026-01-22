class OTPRequest {
  final String email;
  final String otp;

  OTPRequest({
    required this.email,
    required this.otp,
  });

  factory OTPRequest.fromJson(Map<String, dynamic> json) {
    return OTPRequest(
      email: json['email'] as String,
      otp: json['otp'] as String,
    );
  }

  List<String> validate() {
    final errors = <String>[];

    if (email.isEmpty) {
      errors.add('Email is required');
    }

    if (otp.isEmpty || otp.length != 6) {
      errors.add('OTP must be 6 digits');
    }

    return errors;
  }
}
