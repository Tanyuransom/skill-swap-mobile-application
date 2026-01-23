class GoogleAuthRequest {
  final String? accessToken;
  final String? idToken;

  GoogleAuthRequest({
    this.accessToken,
    this.idToken,
  });

  factory GoogleAuthRequest.fromJson(Map<String, dynamic> json) {
    return GoogleAuthRequest(
      accessToken: json['accessToken'] as String?,
      idToken: json['idToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'idToken': idToken,
    };
  }

  void validate() {
    if (idToken == null || idToken!.isEmpty) {
      throw Exception('ID token is required');
    }
  }
}
