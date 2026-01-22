import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../models/profile_model.dart';
import '../models/settings_model.dart';
import '../services/user_service.dart';
import '../../../shared/lib/skillswapp_shared.dart';

class UserController {
  final UserService _userService = UserService();

  /// GET /profile/:userId
  Future<Response> getProfile(Request request, String userId) async {
    try {
      final profile = await _userService.getProfile(userId);
      
      return Response.ok(
        ApiResponse.success(data: profile).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on NotFoundException catch (e) {
      return Response.notFound(
        ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Failed to get profile').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// PUT /profile
  Future<Response> updateProfile(Request request) async {
    try {
      final userId = request.context['userId'] as String?;
      if (userId == null) {
        return Response.unauthorized(
          ApiResponse.error(message: 'Unauthorized').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final body = jsonDecode(await request.readAsString());
      final updateRequest = UpdateProfileRequest.fromJson(body);

      // Validate
      final errors = updateRequest.validate();
      if (errors.isNotEmpty) {
        return Response.badRequest(
          body: ApiResponse.error(
            message: 'Validation failed',
            errors: {'fields': errors},
          ).toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final profile = await _userService.updateProfile(userId, updateRequest);

      return Response.ok(
        ApiResponse.success(
          message: 'Profile updated successfully',
          data: profile,
        ).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Failed to update profile').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// GET /profile/:userId/public
  Future<Response> getPublicProfile(Request request, String userId) async {
    try {
      final profile = await _userService.getPublicProfile(userId);
      
      return Response.ok(
        ApiResponse.success(data: profile).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on NotFoundException catch (e) {
      return Response.notFound(
        ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on ForbiddenException catch (e) {
      return Response.forbidden(
        ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Failed to get profile').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// GET /settings
  Future<Response> getSettings(Request request) async {
    try {
      final userId = request.context['userId'] as String?;
      if (userId == null) {
        return Response.unauthorized(
          ApiResponse.error(message: 'Unauthorized').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final settings = await _userService.getSettings(userId);

      return Response.ok(
        ApiResponse.success(data: settings).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Failed to get settings').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// PUT /settings
  Future<Response> updateSettings(Request request) async {
    try {
      final userId = request.context['userId'] as String?;
      if (userId == null) {
        return Response.unauthorized(
          ApiResponse.error(message: 'Unauthorized').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final body = jsonDecode(await request.readAsString());
      final updateRequest = UpdateSettingsRequest.fromJson(body);

      final settings = await _userService.updateSettings(userId, updateRequest);

      return Response.ok(
        ApiResponse.success(
          message: 'Settings updated successfully',
          data: settings,
        ).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Failed to update settings').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// GET /users (admin)
  Future<Response> listUsers(Request request) async {
    try {
      final userId = request.context['userId'] as String?;
      if (userId == null) {
        return Response.unauthorized(
          ApiResponse.error(message: 'Unauthorized').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
      final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
      final search = request.url.queryParameters['search'];

      final result = await _userService.listUsers(
        requesterId: userId,
        page: page,
        limit: limit,
        search: search,
      );

      return Response.ok(
        ApiResponse.success(data: result).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on ForbiddenException catch (e) {
      return Response.forbidden(
        ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Failed to list users').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// DELETE /users/:userId (admin)
  Future<Response> deleteUser(Request request, String targetUserId) async {
    try {
      final userId = request.context['userId'] as String?;
      if (userId == null) {
        return Response.unauthorized(
          ApiResponse.error(message: 'Unauthorized').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      await _userService.deleteUser(userId, targetUserId);

      return Response.ok(
        ApiResponse.success(message: 'User deleted successfully').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on ForbiddenException catch (e) {
      return Response.forbidden(
        ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on BadRequestException catch (e) {
      return Response.badRequest(
        body: ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Failed to delete user').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// PATCH /users/:userId/status (admin)
  Future<Response> updateUserStatus(Request request, String targetUserId) async {
    try {
      final userId = request.context['userId'] as String?;
      if (userId == null) {
        return Response.unauthorized(
          ApiResponse.error(message: 'Unauthorized').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final body = jsonDecode(await request.readAsString());
      final isActive = body['isActive'] as bool?;

      if (isActive == null) {
        return Response.badRequest(
          body: ApiResponse.error(message: 'isActive is required').toJsonString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      await _userService.updateUserStatus(userId, targetUserId, isActive);

      return Response.ok(
        ApiResponse.success(message: 'User status updated successfully').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } on ForbiddenException catch (e) {
      return Response.forbidden(
        ApiResponse.error(message: e.message).toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: ApiResponse.error(message: 'Failed to update user status').toJsonString(),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
