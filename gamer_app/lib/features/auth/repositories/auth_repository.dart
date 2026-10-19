import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/network/dio_client.dart';

class AuthRepository {
  final DioClient dioClient;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthRepository(this.dioClient);

  // Sync or Login user with the backend
  Future<bool> authenticateUser(String identifier, String password) async {
    try {
      final response = await dioClient.dio.post(
        'auth/sync', 
        data: {
          'identifier': identifier,
          'password': password,
        },
      );

      // Check if the backend returned a token
      if (response.data != null && response.data['token'] != null) {
        String token = response.data['token'];
        
        // Securely store the JWT token for future requests
        await secureStorage.write(key: 'jwt_token', value: token);
        print('--> Auth Success! Token saved.');
        return true;
      }
      return false;
    } catch (e) {
      print('--> Auth Error: $e');
      throw Exception('Authentication failed: $e');
    }
  }

  // Register or sign up a new user via the auth/sync endpoint
  Future<bool> registerUser({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      // Corrected to use relative path matching your Dio baseUrl
      final response = await dioClient.dio.post(
        'auth/sync', 
        data: {
          'email': email,
          'password': password,
          'username': username ?? email.split('@')[0],
        },
      );

      if (response.data != null && response.data['token'] != null) {
        String token = response.data['token'];
        await secureStorage.write(key: 'jwt_token', value: token);
        print('--> Signup Success! Token saved.');
        return true;
      }
      return false;
    } catch (e) {
      print('--> Signup Error: $e');
      throw Exception('Registration failed: $e');
    }
  }
  
  // Handle Google Sign-In/Sync via backend
  Future<bool> googleAuth(String idToken) async {
    try {
      final response = await dioClient.dio.post(
        'auth/sync',
        data: {
          'idToken': idToken,
        },
      );

      if (response.data != null && response.data['token'] != null) {
        String token = response.data['token'];
        await secureStorage.write(key: 'jwt_token', value: token);
        print('--> Google Auth Success! Token saved.');
        return true;
      }
      return false;
    } catch (e) {
      print('--> Google Auth Error: $e');
      throw Exception('Google authentication failed: $e');
    }
  }
}