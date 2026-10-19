import '../entities/challenge.dart';
import '../repositories/challenge_repository.dart';

class CreateChallenge {
  final ChallengeRepository repository;
  CreateChallenge(this.repository);

  Future<void> call(Challenge challenge) async {
    return await repository.createChallenge(challenge);
  }
}