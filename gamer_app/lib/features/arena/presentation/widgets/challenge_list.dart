import 'package:flutter/material.dart';
import 'challenge_card.dart';
import 'empty_state.dart';
import 'package:gamer_app/core/navigation/scroll_aware.dart';

class ChallengeList extends StatelessWidget {
  const ChallengeList({super.key});

  final List<ChallengeCardData> dummyChallenges = const [
    ChallengeCardData(
      gameTitle: 'COD Mobile',
      format: '1v1',
      stake: '₦10,000',
      hostName: 'ApexPredator',
      gameImage: 'https://placeholder.co/100',
      hostAvatar: 'https://placeholder.co/50',
      status: ChallengeStatus.lookingForOpponent,
    ),
    ChallengeCardData(
      gameTitle: 'PUBG Mobile',
      format: '2v2',
      stake: '₦25,000',
      hostName: 'TeamDelta',
      gameImage: 'https://placeholder.co/100',
      hostAvatar: 'https://placeholder.co/50',
      status: ChallengeStatus.live,
      viewersCount: '128',
    ),
    ChallengeCardData(
      gameTitle: 'eFootball',
      format: '1v1',
      stake: '₦5,000',
      hostName: 'FootyKing',
      gameImage: 'https://placeholder.co/100',
      hostAvatar: 'https://placeholder.co/50',
      status: ChallengeStatus.accepted,
      countdownTime: '04:32',
    ),
    ChallengeCardData(
      gameTitle: 'Free Fire',
      format: 'Squad',
      stake: '₦15,000',
      hostName: 'FireLord',
      gameImage: 'https://placeholder.co/100',
      hostAvatar: 'https://placeholder.co/50',
      status: ChallengeStatus.lookingForOpponent,
    ),
    ChallengeCardData(
      gameTitle: 'FC Mobile',
      format: '1v1',
      stake: '₦20,000',
      hostName: 'StrikerX',
      gameImage: 'https://placeholder.co/100',
      hostAvatar: 'https://placeholder.co/50',
      status: ChallengeStatus.live,
      viewersCount: '64',
    ),
    ChallengeCardData(
      gameTitle: 'COD Mobile',
      format: '4v4 Search & Destroy',
      stake: '₦50,000',
      hostName: 'VanguardClan',
      gameImage: 'https://placeholder.co/100',
      hostAvatar: 'https://placeholder.co/50',
      status: ChallengeStatus.lookingForOpponent,
    ),
    ChallengeCardData(
      gameTitle: 'PUBG Mobile',
      format: '1v1 TDM',
      stake: '₦8,000',
      hostName: 'GhostSniper',
      gameImage: 'https://placeholder.co/100',
      hostAvatar: 'https://placeholder.co/50',
      status: ChallengeStatus.accepted,
      countdownTime: '12:05',
    ),
    ChallengeCardData(
      gameTitle: 'eFootball',
      format: '1v1',
      stake: '₦12,000',
      hostName: 'Tactician99',
      gameImage: 'https://placeholder.co/100',
      hostAvatar: 'https://placeholder.co/50',
      status: ChallengeStatus.lookingForOpponent,
    ),
    ChallengeCardData(
      gameTitle: 'Free Fire',
      format: 'Duo',
      stake: '₦10,000',
      hostName: 'BlazeRider',
      gameImage: 'https://placeholder.co/100',
      hostAvatar: 'https://placeholder.co/50',
      status: ChallengeStatus.live,
      viewersCount: '210',
    ),
    ChallengeCardData(
      gameTitle: 'FC Mobile',
      format: '1v1',
      stake: '₦30,000',
      hostName: 'ElMatador',
      gameImage: 'https://placeholder.co/100',
      hostAvatar: 'https://placeholder.co/50',
      status: ChallengeStatus.lookingForOpponent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (dummyChallenges.isEmpty) {
      return const EmptyState();
    }

    return ScrollAware(
  child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    itemCount: dummyChallenges.length,
    itemBuilder: (context, index) {
      return ChallengeCard(challenge: dummyChallenges[index]);
    },
  ),
);
  }
}