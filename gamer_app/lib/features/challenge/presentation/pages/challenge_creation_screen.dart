import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../widgets/game_selector.dart';
import '../widgets/challenge_type_selector.dart';
import '../widgets/region_selector.dart';
import '../widgets/stake_selector.dart';
import '../widgets/publish_button.dart';
import 'challenge_review_sheet.dart';
import '../../domain/entities/challenge.dart';
import '../../../deposit/presentation/pages/deposit_screen.dart';

class ChallengeCreationScreen extends StatefulWidget {
  final String initialGame;
  final String? initialGameImage;
  final String? selectedMode;

  const ChallengeCreationScreen({
    Key? key,
    this.initialGame = 'Call of Duty: Mobile',
    this.initialGameImage,
    this.selectedMode,
  }) : super(key: key);

  @override
  _ChallengeCreationScreenState createState() =>
      _ChallengeCreationScreenState();
}

class _ChallengeCreationScreenState extends State<ChallengeCreationScreen> {
  late String selectedGame;
  late String selectedGameImage;
  String selectedMode = 'Team Deathmatch';
  ChallengeType selectedType = ChallengeType.public;
  final String signupRegion = 'North America';
  double wagerAmount = 500;

  @override
  void initState() {
    super.initState();
    selectedGame = widget.initialGame;
    selectedGameImage =
        widget.initialGameImage ?? 'assets/images/codm_banner.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 18,
        ),
        title: const Text(
          'CREATE CHALLENGE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DepositScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: const [
                  Icon(Icons.add, color: AppColors.gold, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '12,450',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SELECT GAME',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                GameSelector(
                  selectedGame: selectedGame,
                  selectedGameImage: selectedGameImage,
                  selectedMode: selectedMode,
                  onSelect: (g) => setState(() => selectedGame = g),
                ),
                const SizedBox(height: 20),
                const Text(
                  'GAME MODE',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedMode,
                      dropdownColor: AppColors.cardBg,
                      isExpanded: true,
                      style: const TextStyle(color: AppColors.textWhite),
                      items:
                          [
                                'Team Deathmatch',
                                'Search & Destroy',
                                'Free for All',
                              ]
                              .map(
                                (m) =>
                                    DropdownMenuItem(value: m, child: Text(m)),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => selectedMode = v!),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'CHALLENGE TYPE',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ChallengeTypeSelector(
                  selectedType: selectedType,
                  onTypeChanged: (t) => setState(() => selectedType = t),
                ),
                const SizedBox(height: 20),
                const Text(
                  'REGION',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RegionSelector(userRegion: signupRegion),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'WAGER AMOUNT',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '🪙 MIN 100 – MAX 10,000',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                StakeSelector(
                  currentWager: wagerAmount,
                  onWagerChanged: (val) => setState(() => wagerAmount = val),
                ),
                const SizedBox(height: 30),
                PublishButton(
                  label: 'NEXT',
                  onTap: () => showChallengeReviewSheet(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
