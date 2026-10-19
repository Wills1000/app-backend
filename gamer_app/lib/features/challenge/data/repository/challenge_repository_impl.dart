import '../../domain/entities/challenge.dart';
import '../../domain/entities/challenge_history.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../datasource/challenge_remote_datasource.dart';
import '../models/challenge_model.dart';

class ChallengeRepositoryImpl implements ChallengeRepository {
  final ChallengeRemoteDataSource remoteDataSource;

  ChallengeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createChallenge(Challenge challenge) async {
    final model = ChallengeModel(
      id: challenge.id,
      gameName: challenge.gameName,
      gameMode: challenge.gameMode,
      type: challenge.type,
      region: challenge.region,
      wagerAmount: challenge.wagerAmount,
      rules: challenge.rules,
      hostUsername: challenge.hostUsername,
      hostAvatar: challenge.hostAvatar,
      status: challenge.status,
      currentParticipants: challenge.currentParticipants,
      maxParticipants: challenge.maxParticipants,
    );
    return await remoteDataSource.createChallenge(model);
  }

  @override
  Future<void> publishChallenge(String challengeId) async {
    return await remoteDataSource.publishChallenge(challengeId);
  }

  @override
  Future<void> cancelChallenge(String challengeId) async {
    return await remoteDataSource.cancelChallenge(challengeId);
  }

  @override
  Future<List<ChallengeHistoryItem>> getChallengeHistory(String filter) async {
    return await remoteDataSource.fetchChallengeHistory(filter);
  }

  @override
  Future<Challenge> getChallengeDetails(String challengeId) async {
    return await remoteDataSource.fetchChallengeDetails(challengeId);
  }
}