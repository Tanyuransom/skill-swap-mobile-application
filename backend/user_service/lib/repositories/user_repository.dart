import '../../../shared/lib/skillswapp_shared.dart';

class UserRepository {
  /// Get user profile
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final result = await PostgresClient.executeOne(
      'SELECT * FROM profiles WHERE user_id = @userId',
      parameters: {'userId': userId},
    );
    return result?.toColumnMap();
  }

  /// Create user profile
  Future<Map<String, dynamic>> createProfile(String userId) async {
    final result = await PostgresClient.executeOne(
      '''
      INSERT INTO profiles (user_id)
      VALUES (@userId)
      RETURNING *
      ''',
      parameters: {'userId': userId},
    );
    
    if (result == null) {
      throw DatabaseException('Failed to create profile');
    }
    
    return result.toColumnMap();
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    final setClauses = <String>[];
    final params = {'userId': userId};
    
    updates.forEach((key, value) {
      if (value != null) {
        setClauses.add('$key = @$key');
        params[key] = value;
      }
    });
    
    if (setClauses.isEmpty) {
      final profile = await getProfile(userId);
      if (profile == null) throw NotFoundException('Profile not found');
      return profile;
    }
    
    final result = await PostgresClient.executeOne(
      '''
      UPDATE profiles
      SET ${setClauses.join(', ')}, updated_at = NOW()
      WHERE user_id = @userId
      RETURNING *
      ''',
      parameters: params,
    );
    
    if (result == null) {
      throw NotFoundException('Profile not found');
    }
    
    return result.toColumnMap();
  }

  /// Get user settings
  Future<Map<String, dynamic>?> getSettings(String userId) async {
    final result = await PostgresClient.executeOne(
      'SELECT * FROM user_settings WHERE user_id = @userId',
      parameters: {'userId': userId},
    );
    return result?.toColumnMap();
  }

  /// Create user settings
  Future<Map<String, dynamic>> createSettings(String userId) async {
    final result = await PostgresClient.executeOne(
      '''
      INSERT INTO user_settings (user_id)
      VALUES (@userId)
      RETURNING *
      ''',
      parameters: {'userId': userId},
    );
    
    if (result == null) {
      throw DatabaseException('Failed to create settings');
    }
    
    return result.toColumnMap();
  }

  /// Update user settings
  Future<Map<String, dynamic>> updateSettings(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    final setClauses = <String>[];
    final params = {'userId': userId};
    
    updates.forEach((key, value) {
      setClauses.add('$key = @$key');
      params[key] = value;
    });
    
    if (setClauses.isEmpty) {
      final settings = await getSettings(userId);
      if (settings == null) throw NotFoundException('Settings not found');
      return settings;
    }
    
    final result = await PostgresClient.executeOne(
      '''
      UPDATE user_settings
      SET ${setClauses.join(', ')}, updated_at = NOW()
      WHERE user_id = @userId
      RETURNING *
      ''',
      parameters: params,
    );
    
    if (result == null) {
      throw NotFoundException('Settings not found');
    }
    
    return result.toColumnMap();
  }

  /// Get user by ID
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final result = await PostgresClient.executeOne(
      'SELECT id, email, role, first_name, last_name, is_verified, is_active, created_at FROM users WHERE id = @userId',
      parameters: {'userId': userId},
    );
    return result?.toColumnMap();
  }

  /// List users (admin)
  Future<List<Map<String, dynamic>>> listUsers({
    int limit = 20,
    int offset = 0,
    String? search,
  }) async {
    String query = '''
      SELECT id, email, role, first_name, last_name, is_verified, is_active, created_at
      FROM users
    ''';
    
    final params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    
    if (search != null && search.isNotEmpty) {
      query += '''
        WHERE email ILIKE @search 
        OR first_name ILIKE @search 
        OR last_name ILIKE @search
      ''';
      params['search'] = '%$search%';
    }
    
    query += ' ORDER BY created_at DESC LIMIT @limit OFFSET @offset';
    
    final result = await PostgresClient.execute(query, parameters: params);
    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Delete user (admin)
  Future<void> deleteUser(String userId) async {
    await PostgresClient.execute(
      'DELETE FROM users WHERE id = @userId',
      parameters: {'userId': userId},
    );
  }

  /// Update user status (admin)
  Future<void> updateUserStatus(String userId, bool isActive) async {
    await PostgresClient.execute(
      'UPDATE users SET is_active = @isActive, updated_at = NOW() WHERE id = @userId',
      parameters: {'userId': userId, 'isActive': isActive},
    );
  }
}
