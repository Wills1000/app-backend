import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/providers/api_provider.dart';

class GameRepository {
  final DioClient _dioClient;

  GameRepository(this._dioClient);

  Future<List<dynamic>> getActiveChallenges() async {
    try {
      final response = await _dioClient.dio.get('games/challenges');
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load challenges');
    }
  }

  Future<void> submitMatchResult(String challengeId, int score, String proofUrl) async {
    try {
      await _dioClient.dio.post('games/submit-result', data: {
        'challengeId': challengeId,
        'reportedScore': score,
        'proofUrl': proofUrl,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to submit result');
    }
  }
}

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return GameRepository(dioClient);
});