import '../entities/challenge_history.dart';
import '../repositories/challenge_repository.dart';

class GetChallengeHistory {
  final ChallengeRepository repository;
  GetChallengeHistory(this.repository);

  Future<List<ChallengeHistoryItem>> call(String filter) async {
    return await repository.getChallengeHistory(filter);
  }
}