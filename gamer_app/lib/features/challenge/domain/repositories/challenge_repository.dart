import '../entities/challenge.dart';
import '../entities/challenge_history.dart';

abstract class ChallengeRepository {
  Future<void> createChallenge(Challenge challenge);
  Future<void> publishChallenge(String challengeId);
  Future<void> cancelChallenge(String challengeId);
  Future<List<ChallengeHistoryItem>> getChallengeHistory(String filter);
  Future<Challenge> getChallengeDetails(String challengeId);
}