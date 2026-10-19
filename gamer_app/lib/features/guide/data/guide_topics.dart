import 'package:flutter/material.dart';
import '../models/guide_topic_model.dart';

class GuideData {
  static const List<GuideTopicModel> topics = [
    GuideTopicModel(
      id: 'getting_started',
      title: 'Getting Started',
      subtitle: 'Learn the basics of Gamer App',
      icon: Icons.menu_book,
      color: Color(0xFFE50914),
      subTopics: [
        GuideSubTopic(
          id: 'welcome',
          title: 'App Overview',
          description:
              'Gamer App allows players to create 1v1 or team challenges, stake coins in escrow, and earn real rewards upon victory.',
          steps: [
            'Create and verify your account using a valid email and gamer ID.',
            'Connect your gaming tags (COD Mobile, PUBG, Free Fire, FIFA, etc.).',
            'Fund your wallet with coins to participate in staked matches.',
            'Join existing public lobbies or create a custom match challenge.'
          ],
          tip:
              'Always ensure your game username matches your linked platform ID to prevent dispute delays.',
        ),
        GuideSubTopic(
          id: 'linking_account',
          title: 'Linking Game Profiles',
          description:
              'Your game tag is used by opponents and match referees to verify match results.',
          steps: [
            'Go to Profile > Linked Accounts.',
            'Select your primary game (e.g., Call of Duty: Mobile).',
            'Enter your exact In-Game Name (IGN) and Player UID.',
            'Save changes. Unverified profiles cannot host paid rooms.'
          ],
        ),
      ],
    ),
    GuideTopicModel(
      id: 'challenges_matches',
      title: 'Challenges & Matches',
      subtitle: 'How to create, join and win',
      icon: Icons.sports_esports,
      color: Color(0xFF8B5CF6),
      subTopics: [
        GuideSubTopic(
          id: 'create_match',
          title: 'Creating a Challenge',
          description:
              'Host custom 1v1 or squad matches with specified entry fees and custom match rules.',
          steps: [
            'Tap the "Arena" tab and select "Create Match".',
            'Pick your game, mode (1v1, 2v2, Battle Royale), and map.',
            'Set the entry stake per player and room password.',
            'Publish the lobby or send direct invite links to friends.'
          ],
          tip:
              'Stakes are locked in Escrow as soon as both parties accept the challenge.',
        ),
        GuideSubTopic(
          id: 'submitting_results',
          title: 'Submitting Match Results',
          description:
              'How to claim your victory and collect your payout securely.',
          steps: [
            'Take a clear screenshot or screen recording of the final scorecard.',
            'Navigate to Active Matches and tap "Submit Result".',
            'Upload your media proof and mark yourself as Winner or Loser.',
            'If both players agree, funds release instantly to the winner\'s wallet.'
          ],
          tip:
              'Falsifying match proofs leads to immediate account ban and loss of staked deposit.',
        ),
      ],
    ),
    GuideTopicModel(
      id: 'payments_wallet',
      title: 'Payments & Wallet',
      subtitle: 'Add funds, track balance, withdraw',
      icon: Icons.account_balance_wallet,
      color: Color(0xFF10B981),
      subTopics: [
        GuideSubTopic(
          id: 'depositing',
          title: 'Depositing Funds',
          description:
              'Top up your wallet with coins using local card, transfer, or crypto methods.',
          steps: [
            'Open the Wallet screen and tap "Deposit".',
            'Choose your preferred payment provider (Card, Bank Transfer, Apple Pay).',
            'Enter amount and complete authentication.',
            'Coins are credited instantly upon payment confirmation.'
          ],
        ),
        GuideSubTopic(
          id: 'withdrawals',
          title: 'Withdrawing Earnings',
          description:
              'Convert your hard-earned match coins back into local currency or crypto.',
          steps: [
            'Tap "Withdraw" on the Wallet screen.',
            'Select destination account or linked bank details.',
            'Enter withdrawal coin amount (1 Coin = \$0.10 USD).',
            'Confirm with your account security PIN.'
          ],
          tip: 'Standard withdrawals are processed within 5 to 30 minutes.',
        ),
      ],
    ),
    GuideTopicModel(
      id: 'safety_security',
      title: 'Safety & Security',
      subtitle: 'Play safe and follow the rules',
      icon: Icons.shield,
      color: Color(0xFFF59E0B),
      subTopics: [
        GuideSubTopic(
          id: 'escrow_system',
          title: 'How Escrow Works',
          description:
              'Our automated system holds match stakes safely so no player can run away with funds.',
          steps: [
            'Both players deposit entry stakes into Escrow before the match begins.',
            'Match room details become visible only after stakes are locked.',
            'Upon verified result confirmation, Escrow releases 100% of the pool to the victor.'
          ],
        ),
        GuideSubTopic(
          id: 'disputes',
          title: 'Filing a Dispute',
          description:
              'In case of opponent no-show, cheating, or incorrect score claims.',
          steps: [
            'Tap "Dispute Match" on the match summary screen.',
            'Select reason (e.g., Opponent Cheated / Wrong IGN / No-Show).',
            'Attach unedited video clip or screenshot evidence.',
            'A Gamer App moderator will review and settle the match within 1 hour.'
          ],
        ),
      ],
    ),
    GuideTopicModel(
      id: 'account_profile',
      title: 'Account & Profile',
      subtitle: 'Manage your account and settings',
      icon: Icons.person,
      color: Color(0xFF3B82F6),
      subTopics: [
        GuideSubTopic(
          id: 'security_pin',
          title: 'Two-Factor & Security PIN',
          description: 'Protect your wallet balance and match history.',
          steps: [
            'Go to Profile > Security Settings.',
            'Enable 2FA (Authenticator App or SMS).',
            'Set a 4-digit Wallet Transaction PIN required for all withdrawals.'
          ],
        ),
      ],
    ),
  ];
}