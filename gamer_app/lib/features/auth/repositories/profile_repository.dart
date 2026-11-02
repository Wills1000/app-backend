import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
 
// Thrown when a profile request fails. [message] is safe to show to the user.
class ApiException implements Exception {
  final String message;
 
  ApiException(this.message);
 
  @override
  String toString() => message;
}
 
class ProfileRepository {
  final DioClient dioClient;
 
  ProfileRepository(this.dioClient);
 
  // The signed-in user with profile and wallet
  Future<Map<String, dynamic>> getMe() async {
    try {
      final res = await dioClient.dio.get('me');
      return _asMap(res.data);
    } on DioException catch (e) {
      throw _toApiException(e, 'Could not load your profile.');
    }
  }
 
  // Saves profile fields (username, names, date of birth, gender, location, bio...)
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> fields) async {
    try {
      final res = await dioClient.dio.patch('me/profile', data: fields);
      return _asMap(res.data);
    } on DioException catch (e) {
      throw _toApiException(e, 'Could not save your profile.');
    }
  }
 
  // Uploads a profile picture and returns its public URL
  Future<String> uploadAvatar(File file) async {
    try {
      final fileName = file.path.split(Platform.pathSeparator).last;
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });
 
      final res = await dioClient.dio.post(
        'me/avatar',
        data: form,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
 
      final url = _find(res.data, 'avatarUrl');
      if (url is! String) {
        throw ApiException('Photo upload failed. Please try again.');
      }
      return url;
    } on DioException catch (e) {
      throw _toApiException(e, 'Could not upload your photo.');
    }
  }
 
  // --- helpers ---
 
  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map && data['data'] is Map) {
      return Map<String, dynamic>.from(data['data'] as Map);
    }
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }
 
  dynamic _find(dynamic data, String key, [int depth = 0]) {
    if (data is Map && depth < 4) {
      if (data.containsKey(key)) return data[key];
      for (final v in data.values) {
        final found = _find(v, key, depth + 1);
        if (found != null) return found;
      }
    }
    return null;
  }
 
  ApiException _toApiException(DioException e, String fallback) {
    if (e.response == null) {
      return ApiException(
        'Could not reach the server. Please check your connection and try again.',
      );
    }
 
    final data = e.response?.data;
    dynamic m = data is Map ? data['message'] : null;
    if (m is Map) m = m['message'];
    if (m is List && m.isNotEmpty) return ApiException(m.first.toString());
    if (m is String && m.isNotEmpty) return ApiException(m);
 
    if (e.response?.statusCode == 401) {
      return ApiException('Your session expired. Please sign in again.');
    }
    return ApiException(fallback);
  }
}
 