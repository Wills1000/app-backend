import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/../../core/providers/api_provider.dart';

final userProfileProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final dioClient = ref.watch(dioClientProvider);
  final response = await dioClient.dio.get('users/profile');
  return response.data;
});

final homeStatsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final dioClient = ref.watch(dioClientProvider);
  final response = await dioClient.dio.get('users/stats');
  return response.data;
});