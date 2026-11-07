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
      throw VerificationException(_friendlyAuthError(e));
    } on DioException catch (e) {
      throw VerificationException(_serverMessage(e, 'Could not sign you in'));
    } catch (_) {
      throw VerificationException('Something went wrong. Please try again.');
    }
  }
 
  // Checks (before creating the account) that the username and phone number
  // are valid and not already used
  Future<void> _ensureDetailsAvailable(String username, String phone) async {
    try {
      final res = await dioClient.dio.get(
        'auth/username-available',
        queryParameters: {
          'username': username,
          if (phone.isNotEmpty) 'phone': phone,
        },
      );
 
      if (_find(res.data, 'available') != true) {
        final msg = _find(res.data, 'message');
        throw VerificationException(
          msg is String ? msg : 'That username or phone number is already used',
        );
      }
    } on DioException catch (e) {
      throw VerificationException(
        _serverMessage(e, 'Could not check your details'),
      );
    }
  }
 
  // Saves the username chosen at signup to the new profile
  Future<void> _saveUsername(String username) async {
    try {
      await dioClient.dio.patch('me/profile', data: {'username': username});
    } on DioException {
      // Very rare (someone took it a second ago): keep the generated username
    }
  }
 
  // Saves the phone number entered at signup
  Future<void> _savePhone(String phone) async {
    try {
      await dioClient.dio.patch('me/phone', data: {'phone': phone});
    } on DioException {
      // Very rare (taken a second ago): the account is still created
    }
  }
 
  // Sign up: check the details, create the user in Firebase, then sync with backend
  Future<bool> registerUser({
    required String email,
    required String password,
    String? username,
    String? phone,
  }) async {
    final wantedUsername = (username ?? '').trim();
    final wantedPhone = (phone ?? '').replaceAll(RegExp(r'[\s\-()]'), '');
 
    try {
      if (wantedUsername.isNotEmpty) {
        await _ensureDetailsAvailable(wantedUsername, wantedPhone);
      }
 
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
 
      bool synced;
      try {
        synced = await _syncWithBackend();
      } on DioException catch (e) {
        // The server step failed: undo the Firebase account so the user
        // can try again with the same email
        try {
          await _auth.currentUser?.delete();
        } catch (_) {}
        throw VerificationException(
          _serverMessage(e, 'Could not finish creating your account'),
        );
      }
 
      if (wantedUsername.isNotEmpty) {
        await _saveUsername(wantedUsername);
      }
      if (wantedPhone.isNotEmpty) {
        await _savePhone(wantedPhone);
      }
 
      return synced;
    } on VerificationException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw VerificationException(_friendlyAuthError(e));
    } catch (_) {
      throw VerificationException('Something went wrong. Please try again.');
    }
  }
 
  // Google sign-in: pass the Google idToken, sign in to Firebase, then sync
  Future<bool> googleAuth(String idToken) async {
    try {
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await _auth.signInWithCredential(credential);
      return await _syncWithBackend();
    } on FirebaseAuthException catch (e) {
      throw VerificationException(_friendlyAuthError(e));
    } on DioException catch (e) {
      throw VerificationException(_serverMessage(e, 'Could not sign you in'));
    } catch (_) {
      throw VerificationException('Something went wrong. Please try again.');
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
 
  // Turns a failed server request into a message the user can read.
  // Without a response (no internet / server asleep) it explains that;
  // with a response it shows the server's message and the status code.
  String _serverMessage(DioException e, String fallback) {
    final status = e.response?.statusCode;
 
    if (status == null) {
      return 'Could not reach the server. Please check your connection and try again '
          '(the first request can take up to a minute).';
    }
 
    return _messageFrom(e.response?.data, '$fallback (error $status)');
  }
 
  // Turns Firebase's error codes into plain messages
  String _friendlyAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'That email is already registered. Try logging in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      default:
        return e.message ?? e.code;
    }
  }
 
 
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
 