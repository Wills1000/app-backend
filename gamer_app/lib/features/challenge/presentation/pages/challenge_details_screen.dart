import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_background.dart';
import 'package:gamer_app/features/challenge_acceptance/presentation/pages/challenge_acceptance_sheet.dart';

class ChallengeDetailsScreen extends StatelessWidget {
  const ChallengeDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
  icon: const Icon(
    Icons.arrow_back_ios,
    color: Colors.white,
    size: 18,
  ),
  onPressed: () {
    Navigator.pop(context);
  },
),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: AppColors.textWhite),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Game Header Title & Subtitle
                const Text(
                  'Call of Duty: Mobile',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Team Deathmatch • Public',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),

                // Game Banner Image (compact height)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg.withOpacity(0.8),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&q=80&w=800',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Host & Challenge ID Info Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.cardBg,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Hosted by',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                            ),
                            SizedBox(height: 1),
                            Text(
                              '@gamerbeast',
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Challenge ID',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                        SizedBox(height: 1),
                        Text(
                          '#CHL-78452',
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Unified Wager & Participants Card
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Wager',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(Icons.monetization_on, color: AppColors.gold, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  '500',
                                  style: TextStyle(
                                    color: AppColors.textWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 32,
                        width: 1,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Participants',
                                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '1 / 2',
                                style: TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Details Section
                const Text(
                  'Details',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                _buildDetailRow('Game Mode', 'Team Deathmatch'),
                _buildDetailRow('Region', 'North America'),
                _buildDetailRow('Challenge Type', 'Public'),
                _buildDetailRow('Best of', '3'),

                const SizedBox(height: 14),

                // Rules Section
                const Text(
                  'Rules',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                _buildRuleItem('No cheating / No hacks'),
                _buildRuleItem('Respectful play'),
                _buildRuleItem('No toxic behavior'),

                // Flexes space directly to push bottom button nicely
                const Spacer(),

                // CTA Button: Accept Challenge
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ChallengeAcceptanceSheet(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Accept Challenge',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String ruleText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00E676), width: 1.5),
            ),
            child: const Icon(
              Icons.check,
              size: 10,
              color: Color(0xFF00E676),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            ruleText,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}