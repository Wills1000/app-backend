abstract class ChallengeLocalDataSource {
  Future<void> cacheDraftChallenge(Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getDraftChallenge();
}

class ChallengeLocalDataSourceImpl implements ChallengeLocalDataSource {
  Map<String, dynamic>? _cache;

  @override
  Future<void> cacheDraftChallenge(Map<String, dynamic> data) async {
    _cache = data;
  }

  @override
  Future<Map<String, dynamic>?> getDraftChallenge() async {
    return _cache;
  }
}