class UserSettingsModel {
  final String userId;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final bool marketingEmails;
  final String language;
  final String timezone;
  final bool profilePublic;
  final bool showEmail;
  final bool showPhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserSettingsModel({
    required this.userId,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.smsNotifications,
    required this.marketingEmails,
    required this.language,
    required this.timezone,
    required this.profilePublic,
    required this.showEmail,
    required this.showPhone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserSettingsModel.fromMap(Map<String, dynamic> map) {
    return UserSettingsModel(
      userId: map['user_id'],
      emailNotifications: map['email_notifications'] ?? true,
      pushNotifications: map['push_notifications'] ?? true,
      smsNotifications: map['sms_notifications'] ?? false,
      marketingEmails: map['marketing_emails'] ?? false,
      language: map['language'] ?? 'en',
      timezone: map['timezone'] ?? 'UTC',
      profilePublic: map['profile_public'] ?? true,
      showEmail: map['show_email'] ?? false,
      showPhone: map['show_phone'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
      'marketingEmails': marketingEmails,
      'language': language,
      'timezone': timezone,
      'profilePublic': profilePublic,
      'showEmail': showEmail,
      'showPhone': showPhone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class UpdateSettingsRequest {
  final bool? emailNotifications;
  final bool? pushNotifications;
  final bool? smsNotifications;
  final bool? marketingEmails;
  final String? language;
  final String? timezone;
  final bool? profilePublic;
  final bool? showEmail;
  final bool? showPhone;

  UpdateSettingsRequest({
    this.emailNotifications,
    this.pushNotifications,
    this.smsNotifications,
    this.marketingEmails,
    this.language,
    this.timezone,
    this.profilePublic,
    this.showEmail,
    this.showPhone,
  });

  factory UpdateSettingsRequest.fromJson(Map<String, dynamic> json) {
    return UpdateSettingsRequest(
      emailNotifications: json['emailNotifications'],
      pushNotifications: json['pushNotifications'],
      smsNotifications: json['smsNotifications'],
      marketingEmails: json['marketingEmails'],
      language: json['language'],
      timezone: json['timezone'],
      profilePublic: json['profilePublic'],
      showEmail: json['showEmail'],
      showPhone: json['showPhone'],
    );
  }
}
