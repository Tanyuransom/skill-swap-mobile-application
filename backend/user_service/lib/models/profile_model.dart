class ProfileModel {
  final String userId;
  final String? bio;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? location;
  final String? website;
  final String? linkedinUrl;
  final String? githubUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.userId,
    this.bio,
    this.avatarUrl,
    this.phoneNumber,
    this.location,
    this.website,
    this.linkedinUrl,
    this.githubUrl,
    this.dateOfBirth,
    this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      userId: map['user_id'],
      bio: map['bio'],
      avatarUrl: map['avatar_url'],
      phoneNumber: map['phone_number'],
      location: map['location'],
      website: map['website'],
      linkedinUrl: map['linkedin_url'],
      githubUrl: map['github_url'],
      dateOfBirth: map['date_of_birth'] != null ? DateTime.parse(map['date_of_birth']) : null,
      gender: map['gender'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'location': location,
      'website': website,
      'linkedinUrl': linkedinUrl,
      'githubUrl': githubUrl,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class UpdateProfileRequest {
  final String? bio;
  final String? phoneNumber;
  final String? location;
  final String? website;
  final String? linkedinUrl;
  final String? githubUrl;
  final String? dateOfBirth;
  final String? gender;

  UpdateProfileRequest({
    this.bio,
    this.phoneNumber,
    this.location,
    this.website,
    this.linkedinUrl,
    this.githubUrl,
    this.dateOfBirth,
    this.gender,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequest(
      bio: json['bio'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
      website: json['website'],
      linkedinUrl: json['linkedinUrl'],
      githubUrl: json['githubUrl'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
    );
  }

  List<String> validate() {
    final errors = <String>[];
    
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phoneNumber!)) {
        errors.add('Invalid phone number format');
      }
    }
    
    if (website != null && website!.isNotEmpty) {
      final uri = Uri.tryParse(website!);
      if (uri == null || !uri.hasScheme) {
        errors.add('Invalid website URL');
      }
    }
    
    if (gender != null && !['male', 'female', 'other', 'prefer_not_to_say'].contains(gender)) {
      errors.add('Invalid gender value');
    }
    
    return errors;
  }
}
