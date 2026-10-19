import '../models/challenge_model.dart';
import '../models/challenge_history_model.dart';
import '../../domain/entities/challenge.dart';

abstract class ChallengeRemoteDataSource {
  Future<void> createChallenge(ChallengeModel model);
  Future<void> publishChallenge(String challengeId);
  Future<void> cancelChallenge(String challengeId);
  Future<List<ChallengeHistoryModel>> fetchChallengeHistory(String filter);
  Future<ChallengeModel> fetchChallengeDetails(String challengeId);
}

class ChallengeRemoteDataSourceImpl implements ChallengeRemoteDataSource {
  @override
  Future<void> createChallenge(ChallengeModel model) async {}

  @override
  Future<void> publishChallenge(String challengeId) async {}

  @override
  Future<void> cancelChallenge(String challengeId) async {}

  @override
  Future<List<ChallengeHistoryModel>> fetchChallengeHistory(String filter) async {
    return const [
      ChallengeHistoryModel(
        id: '1',
        gameTitle: 'Call of Duty',
        mode: 'Team Deathmatch',
        opponentUsername: '@shadowx',
        result: 'Won',
        score: '2 - 1',
        wager: 500,
        timeAgo: '2h ago',
      ),
      ChallengeHistoryModel(
        id: '2',
        gameTitle: 'PUBG Mobile',
        mode: 'Squad',
        opponentUsername: '@venomyt',
        result: 'Lost',
        score: '1 - 2',
        wager: 800,
        timeAgo: '1d ago',
      ),
      ChallengeHistoryModel(
        id: '3',
        gameTitle: 'Free Fire MAX',
        mode: 'Clash Squad',
        opponentUsername: '@killerzone',
        result: 'Cancelled',
        score: '-',
        wager: 300,
        timeAgo: '2d ago',
      ),
      ChallengeHistoryModel(
        id: '4',
        gameTitle: 'FC Mobile',
        mode: 'Head to Head',
        opponentUsername: '@ronaldo7',
        result: 'Won',
        score: '3 - 1',
        wager: 1000,
        timeAgo: '3d ago',
      ),
    ];
  }

  @override
  Future<ChallengeModel> fetchChallengeDetails(String challengeId) async {
    return const ChallengeModel(
      id: '#CHL-78452',
      gameName: 'Call of Duty: Mobile',
      gameMode: 'Team Deathmatch',
      type: ChallengeType.public,
      region: 'North America',
      wagerAmount: 500,
      rules: ['No cheating / No hacks', 'Respectful play', 'No toxic behavior'],
      hostUsername: '@gamerbeast',
      hostAvatar: 'assets/avatar.png',
      status: 'Active',
      currentParticipants: 1,
      maxParticipants: 2,
    );
  }
}