import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/../../core/providers/api_provider.dart';

final activeChallengesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final dioClient = ref.watch(dioClientProvider);
  final response = await dioClient.dio.get('games/challenges');
  return response.data;
});

final waitingRoomProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, challengeId) async {
  final dioClient = ref.watch(dioClientProvider);
  final response = await dioClient.dio.get('games/challenge/$challengeId');
  return response.data;
});