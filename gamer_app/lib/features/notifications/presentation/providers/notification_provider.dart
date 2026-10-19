import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/../../core/providers/api_provider.dart';

final notificationsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final dioClient = ref.watch(dioClientProvider);
  final response = await dioClient.dio.get('notifications');
  return response.data;
});