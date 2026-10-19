import '../../domain/entities/challenge.dart';

class ChallengeModel extends Challenge {
  const ChallengeModel({
    required String id,
    required String gameName,
    required String gameMode,
    required ChallengeType type,
    required String region,
    required double wagerAmount,
    required List<String> rules,
    required String hostUsername,
    required String hostAvatar,
    required String status,
    required int currentParticipants,
    required int maxParticipants,
  }) : super(
          id: id,
          gameName: gameName,
          gameMode: gameMode,
          type: type,
          region: region,
          wagerAmount: wagerAmount,
          rules: rules,
          hostUsername: hostUsername,
          hostAvatar: hostAvatar,
          status: status,
          currentParticipants: currentParticipants,
          maxParticipants: maxParticipants,
        );

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'],
      gameName: json['gameName'],
      gameMode: json['gameMode'],
      type: json['type'] == 'Private' ? ChallengeType.private : ChallengeType.public,
      region: json['region'],
      wagerAmount: (json['wagerAmount'] as num).toDouble(),
      rules: List<String>.from(json['rules'] ?? []),
      hostUsername: json['hostUsername'],
      hostAvatar: json['hostAvatar'],
      status: json['status'],
      currentParticipants: json['currentParticipants'],
      maxParticipants: json['maxParticipants'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameName': gameName,
      'gameMode': gameMode,
      'type': type == ChallengeType.private ? 'Private' : 'Public',
      'region': region,
      'wagerAmount': wagerAmount,
      'rules': rules,
      'hostUsername': hostUsername,
      'hostAvatar': hostAvatar,
      'status': status,
      'currentParticipants': currentParticipants,
      'maxParticipants': maxParticipants,
    };
  }
}