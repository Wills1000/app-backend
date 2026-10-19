import '../repositories/challenge_repository.dart';

class CancelChallenge {
  final ChallengeRepository repository;
  CancelChallenge(this.repository);

  Future<void> call(String challengeId) async {
    return await repository.cancelChallenge(challengeId);
  }
}