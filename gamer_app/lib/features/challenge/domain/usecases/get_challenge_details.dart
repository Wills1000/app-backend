import '../entities/challenge.dart';
import '../repositories/challenge_repository.dart';

class GetChallengeDetails {
  final ChallengeRepository repository;
  GetChallengeDetails(this.repository);

  Future<Challenge> call(String id) async {
    return await repository.getChallengeDetails(id);
  }
}