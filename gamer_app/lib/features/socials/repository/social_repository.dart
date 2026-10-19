import '/core/network/dio_client.dart';

class SocialRepository {
  final DioClient dioClient;

  SocialRepository(this.dioClient);

  Future<List<dynamic>> getFriends() async {
    try {
      final response = await dioClient.dio.get('/social/friends');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load friends: $e');
    }
  }

  Future<List<dynamic>> getFollowers() async {
    try {
      final response = await dioClient.dio.get('/social/followers');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load followers: $e');
    }
  }
}