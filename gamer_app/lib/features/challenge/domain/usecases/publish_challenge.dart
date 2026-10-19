import '../repositories/challenge_repository.dart';

class PublishChallenge {
  final ChallengeRepository repository;
  PublishChallenge(this.repository);

  Future<void> call(String challengeId) async {
    return await repository.publishChallenge(challengeId);
  }
}