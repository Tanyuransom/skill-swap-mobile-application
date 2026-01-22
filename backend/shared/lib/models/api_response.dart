import 'dart:convert';
import 'package:shelf/shelf.dart';

class ApiResponse {
  final bool success;
  final String? message;
  final dynamic data;
  final Map<String, dynamic>? errors;
  final Map<String, dynamic>? meta;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.meta,
  });

  /// Success response
  factory ApiResponse.success({
    String? message,
    dynamic data,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
      meta: meta,
    );
  }

  /// Error response
  factory ApiResponse.error({
    required String message,
    Map<String, dynamic>? errors,
    dynamic data,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      errors: errors,
      data: data,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'success': success,
    };

    if (message != null) json['message'] = message;
    if (data != null) json['data'] = data;
    if (errors != null) json['errors'] = errors;
    if (meta != null) json['meta'] = meta;

    return json;
  }

  /// Convert to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Convert to Shelf Response
  Response toResponse({int statusCode = 200}) {
    return Response(
      statusCode,
      body: toJsonString(),
      headers: {'Content-Type': 'application/json'},
    );
  }

  /// From JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'],
      errors: json['errors'] as Map<String, dynamic>?,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}
