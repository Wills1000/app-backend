import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/network/dio_client.dart';
 
// Thrown when sending or checking a verification code fails.
// [message] is safe to show to the user.
class VerificationException implements Exception {
  final String message;
  final int? resendInSeconds;
 
  VerificationException(this.message, {this.resendInSeconds});
 
  @override
  String toString() => message;
}
 
class SendCodeResult {
  final bool alreadyVerified;
  final int resendInSeconds;
 
  SendCodeResult({required this.alreadyVerified, required this.resendInSeconds});
}
 
class AuthRepository {
  final DioClient dioClient;
  final FirebaseAuth _auth = FirebaseAuth.instance;
 
  AuthRepository(this.dioClient);
 
  // Tells the backend about the signed-in Firebase user.
  // The Dio client adds the Firebase token automatically.
  Future<bool> _syncWithBackend() async {
    final response = await dioClient.dio.post('auth/sync');
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
 
  // Sign up: create the user in Firebase first, then sync with backend
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
      return await _syncWithBackend();
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
 
  // ---------------------------------------------------------------------------
  // Email verification (6-digit code)
  // ---------------------------------------------------------------------------
 
  // Asks the backend to email a 6-digit code to the signed-in user.
  Future<SendCodeResult> sendVerificationCode() async {
    try {
      final res = await dioClient.dio.post('auth/send-code');
      final verified = _find(res.data, 'verified') == true;
      final wait = _find(res.data, 'resendInSeconds');
      return SendCodeResult(
        alreadyVerified: verified,
        resendInSeconds: wait is int ? wait : 60,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw VerificationException(
          'Could not reach the server. Please check your connection and try again.',
        );
      }
      final data = e.response?.data;
      throw VerificationException(
        _messageFrom(data, 'Could not send the verification code.'),
        resendInSeconds: e.response?.statusCode == 429 ? _waitFrom(data) : null,
      );
    }
  }
 
  // Sends the code the user typed. Returns normally when it is correct.
  Future<void> verifyCode(String code) async {
    try {
      final res = await dioClient.dio.post(
        'auth/verify-code',
        data: {'code': code},
      );
      if (_find(res.data, 'verified') != true) {
        throw VerificationException('Verification failed. Please try again.');
      }
    } on DioException catch (e) {
      if (e.response == null) {
        throw VerificationException(
          'Could not reach the server. Please check your connection and try again.',
        );
      }
      throw VerificationException(
        _messageFrom(e.response?.data, 'Verification failed. Please try again.'),
      );
    }
  }
 
  // --- helpers to read the backend's responses safely ---
 
  // Looks for [key] in a (possibly nested) response map.
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
 
  String _messageFrom(dynamic data, String fallback) {
    dynamic m = data is Map ? data['message'] : null;
    if (m is Map) m = m['message'];
    if (m is List && m.isNotEmpty) return m.first.toString();
    if (m is String && m.isNotEmpty) return m;
    final err = data is Map ? data['error'] : null;
    if (err is String && err.isNotEmpty) return err;
    if (err is Map && err['message'] is String) return err['message'] as String;
    return fallback;
  }
 
  int? _waitFrom(dynamic data) {
    final v = _find(data, 'resendInSeconds');
    if (v is int) return v;
    final match = RegExp(r'wait (\d+)s').firstMatch(_messageFrom(data, ''));
    return match == null ? null : int.tryParse(match.group(1)!);
  }
}
 