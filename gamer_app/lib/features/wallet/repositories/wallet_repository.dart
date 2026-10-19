import '/core/network/dio_client.dart';

class WalletRepository {
  final DioClient dioClient;

  WalletRepository(this.dioClient);

  Future<Map<String, dynamic>> getWalletMe() async {
    try {
      final response = await dioClient.dio.get('/wallet/me');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load wallet data: $e');
    }
  }

  Future<Map<String, dynamic>> getBalance() async {
    try {
      final response = await dioClient.dio.get('/wallet/balance');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch balance: $e');
    }
  }

  Future<List<dynamic>> getTransactionHistory() async {
    try {
      final response = await dioClient.dio.get('/wallet/history');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch transaction history: $e');
    }
  }
}