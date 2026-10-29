import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart'; // Make sure Dio package is imported for Options if needed
import '../../../../core/network/dio_client.dart';

class AuthRepository {
  final DioClient dioClient;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthRepository(this.dioClient);

  // Tells the backend about the signed-in Firebase user and passes user data
  Future<bool> _syncWithBackend({Map<String, dynamic>? extraData}) async {
    // 1. Explicitly grab a fresh Firebase ID token to prevent 401 errors
    final user = _auth.currentUser;
    final token = await user?.getIdToken(true);

    // 2. Send the request with the explicit Bearer token and payload data
    final response = await dioClient.dio.post(
      'auth/sync',
      data: extraData ?? {},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Log in with email + password, then sync with backend
  Future<bool> authenticateUser(String identifier, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: identifier,
        password: password,
      );
      return await _syncWithBackend();
    } on FirebaseAuthException catch (e) {
      throw Exception('Authentication failed: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Authentication failed: $e');
    }
  }

  // Sign up: create the user in Firebase first, then sync with backend & username
  Future<bool> registerUser({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Pass the username and email to your backend sync route
      return await _syncWithBackend(extraData: {
        'username': username,
        'email': email,
      });
    } on FirebaseAuthException catch (e) {
      throw Exception('Registration failed: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Google sign-in: pass the Google idToken, sign in to Firebase, then sync
  Future<bool> googleAuth(String idToken) async {
    try {
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await _auth.signInWithCredential(credential);
      return await _syncWithBackend();
    } on FirebaseAuthException catch (e) {
      throw Exception('Google authentication failed: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Google authentication failed: $e');
    }
  }
}