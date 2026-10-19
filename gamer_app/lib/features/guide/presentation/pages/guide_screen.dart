import 'package:flutter/material.dart';
import 'package:gamer_app/core/widgets/app_background.dart';
import '../../data/guide_topics.dart';
import '../../models/guide_topic_model.dart';
import '../widgets/guide_header.dart';
import '../widgets/guide_action_card.dart';
import '../widgets/guide_topic_card.dart';
import '../widgets/guide_search_bar.dart';
import 'guide_topic_details_screen.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  bool _isSearching = false;
  String _searchQuery = '';

  void _openTopicDetails(GuideTopicModel topic, {int initialSubIndex = 0}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GuideTopicDetailsScreen(
          topic: topic,
          initialSubIndex: initialSubIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTopics = GuideData.topics.where((topic) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return topic.title.toLowerCase().contains(q) ||
          topic.subtitle.toLowerCase().contains(q) ||
          topic.subTopics.any((s) =>
              s.title.toLowerCase().contains(q) ||
              s.description.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Guide',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchQuery = '';
              });
            },
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isSearching) ...[
                  GuideSearchBar(
                    onChanged: (val) {
                      setState(() => _searchQuery = val);
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Hero Banner
                const GuideHeader(),
                const SizedBox(height: 24),

                // Quick Start Grid Section
                const Text(
                  'Quick Start',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.72, // Fixed overflow by increasing available height ratio
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    GuideActionCard(
                      title: 'How\nit Works',
                      icon: Icons.play_circle_fill,
                      color: const Color(0xFFE50914),
                      onTap: () => _openTopicDetails(GuideData.topics[0]),
                    ),
                    GuideActionCard(
                      title: 'Create\nChallenge',
                      icon: Icons.emoji_events,
                      color: const Color(0xFF8B5CF6),
                      onTap: () => _openTopicDetails(GuideData.topics[1]),
                    ),
                    GuideActionCard(
                      title: 'Make\nPayment',
                      icon: Icons.account_balance_wallet,
                      color: const Color(0xFF10B981),
                      onTap: () => _openTopicDetails(GuideData.topics[2]),
                    ),
                    GuideActionCard(
                      title: 'Get\nPaid',
                      icon: Icons.monetization_on,
                      color: const Color(0xFFF59E0B),
                      onTap: () => _openTopicDetails(GuideData.topics[2], initialSubIndex: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Browse Topics Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Browse Topics',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: Color(0xFFE50914),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredTopics.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final topic = filteredTopics[index];
                    return GuideTopicCard(
                      topic: topic,
                      onTap: () => _openTopicDetails(topic),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}