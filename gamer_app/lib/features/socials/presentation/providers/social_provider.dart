import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/../../core/providers/api_provider.dart';

final feedProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final dioClient = ref.watch(dioClientProvider);
  final response = await dioClient.dio.get('social/feed');
  return response.data;
});

final userStatusProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final dioClient = ref.watch(dioClientProvider);
  final response = await dioClient.dio.get('social/status');
  return response.data;
});