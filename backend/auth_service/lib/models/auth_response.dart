class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user,
    };
  }
}
