import '../models/profile_model.dart';
import '../models/settings_model.dart';
import '../repositories/user_repository.dart';
import '../../../shared/lib/skillswapp_shared.dart';

class UserService {
  final UserRepository _repository = UserRepository();

  /// Get user profile
  Future<Map<String, dynamic>> getProfile(String userId) async {
    var profile = await _repository.getProfile(userId);
    
    // Create profile if it doesn't exist
    if (profile == null) {
      profile = await _repository.createProfile(userId);
    }
    
    final user = await _repository.getUserById(userId);
    if (user == null) {
      throw NotFoundException('User not found');
    }
    
    return {
      ...user,
      'profile': ProfileModel.fromMap(profile).toJson(),
    };
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile(
    String userId,
    UpdateProfileRequest request,
  ) async {
    // Ensure profile exists
    var profile = await _repository.getProfile(userId);
    if (profile == null) {
      profile = await _repository.createProfile(userId);
    }
    
    // Build updates map
    final updates = <String, dynamic>{};
    if (request.bio != null) updates['bio'] = request.bio;
    if (request.phoneNumber != null) updates['phone_number'] = request.phoneNumber;
    if (request.location != null) updates['location'] = request.location;
    if (request.website != null) updates['website'] = request.website;
    if (request.linkedinUrl != null) updates['linkedin_url'] = request.linkedinUrl;
    if (request.githubUrl != null) updates['github_url'] = request.githubUrl;
    if (request.dateOfBirth != null) updates['date_of_birth'] = request.dateOfBirth;
    if (request.gender != null) updates['gender'] = request.gender;
    
    final updatedProfile = await _repository.updateProfile(userId, updates);
    
    return ProfileModel.fromMap(updatedProfile).toJson();
  }

  /// Get public profile
  Future<Map<String, dynamic>> getPublicProfile(String userId) async {
    final user = await _repository.getUserById(userId);
    if (user == null) {
      throw NotFoundException('User not found');
    }
    
    final profile = await _repository.getProfile(userId);
    final settings = await _repository.getSettings(userId);
    
    // Check privacy settings
    final settingsModel = settings != null 
        ? UserSettingsModel.fromMap(settings) 
        : null;
    
    if (settingsModel != null && !settingsModel.profilePublic) {
      throw ForbiddenException('Profile is private');
    }
    
    return {
      'id': user['id'],
      'firstName': user['first_name'],
      'lastName': user['last_name'],
      'role': user['role'],
      'bio': profile?['bio'],
      'avatarUrl': profile?['avatar_url'],
      'location': profile?['location'],
      'website': profile?['website'],
      'linkedinUrl': profile?['linkedin_url'],
      'githubUrl': profile?['github_url'],
      'email': settingsModel?.showEmail == true ? user['email'] : null,
      'phoneNumber': settingsModel?.showPhone == true && profile != null ? profile['phone_number'] : null,
    };
  }

  /// Get user settings
  Future<Map<String, dynamic>> getSettings(String userId) async {
    var settings = await _repository.getSettings(userId);
    
    // Create settings if they don't exist
    if (settings == null) {
      settings = await _repository.createSettings(userId);
    }
    
    return UserSettingsModel.fromMap(settings).toJson();
  }

  /// Update user settings
  Future<Map<String, dynamic>> updateSettings(
    String userId,
    UpdateSettingsRequest request,
  ) async {
    // Ensure settings exist
    var settings = await _repository.getSettings(userId);
    if (settings == null) {
      settings = await _repository.createSettings(userId);
    }
    
    // Build updates map
    final updates = <String, dynamic>{};
    if (request.emailNotifications != null) {
      updates['email_notifications'] = request.emailNotifications;
    }
    if (request.pushNotifications != null) {
      updates['push_notifications'] = request.pushNotifications;
    }
    if (request.smsNotifications != null) {
      updates['sms_notifications'] = request.smsNotifications;
    }
    if (request.marketingEmails != null) {
      updates['marketing_emails'] = request.marketingEmails;
    }
    if (request.language != null) updates['language'] = request.language;
    if (request.timezone != null) updates['timezone'] = request.timezone;
    if (request.profilePublic != null) {
      updates['profile_public'] = request.profilePublic;
    }
    if (request.showEmail != null) updates['show_email'] = request.showEmail;
    if (request.showPhone != null) updates['show_phone'] = request.showPhone;
    
    final updatedSettings = await _repository.updateSettings(userId, updates);
    
    return UserSettingsModel.fromMap(updatedSettings).toJson();
  }

  /// List users (admin only)
  Future<Map<String, dynamic>> listUsers({
    required String requesterId,
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    // Check if requester is admin
    final requester = await _repository.getUserById(requesterId);
    if (requester == null || requester['role'] != 'admin') {
      throw ForbiddenException('Admin access required');
    }
    
    final offset = (page - 1) * limit;
    final users = await _repository.listUsers(
      limit: limit,
      offset: offset,
      search: search,
    );
    
    return {
      'users': users,
      'page': page,
      'limit': limit,
      'total': users.length,
    };
  }

  /// Delete user (admin only)
  Future<void> deleteUser(String requesterId, String userId) async {
    // Check if requester is admin
    final requester = await _repository.getUserById(requesterId);
    if (requester == null || requester['role'] != 'admin') {
      throw ForbiddenException('Admin access required');
    }
    
    // Cannot delete self
    if (requesterId == userId) {
      throw BadRequestException('Cannot delete your own account');
    }
    
    await _repository.deleteUser(userId);
  }

  /// Update user status (admin only)
  Future<void> updateUserStatus(
    String requesterId,
    String userId,
    bool isActive,
  ) async {
    // Check if requester is admin
    final requester = await _repository.getUserById(requesterId);
    if (requester == null || requester['role'] != 'admin') {
      throw ForbiddenException('Admin access required');
    }
    
    await _repository.updateUserStatus(userId, isActive);
  }
}
