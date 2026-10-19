import 'package:flutter/material.dart';
import 'package:gamer_app/core/widgets/app_background.dart';
import '../../models/guide_topic_model.dart';
import '../widgets/guide_topic_tab.dart';
import '../widgets/guide_section_card.dart';
import '../widgets/guide_info_card.dart';

class GuideTopicDetailsScreen extends StatefulWidget {
  final GuideTopicModel topic;
  final int initialSubIndex;

  const GuideTopicDetailsScreen({
    Key? key,
    required this.topic,
    this.initialSubIndex = 0,
  }) : super(key: key);

  @override
  State<GuideTopicDetailsScreen> createState() => _GuideTopicDetailsScreenState();
}

class _GuideTopicDetailsScreenState extends State<GuideTopicDetailsScreen> {
  late int _selectedSubIndex;

  @override
  void initState() {
    super.initState();
    _selectedSubIndex = widget.initialSubIndex;
  }

  @override
  Widget build(BuildContext context) {
    final activeSub = widget.topic.subTopics[_selectedSubIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.topic.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sub-Topic Tabs Header
                if (widget.topic.subTopics.length > 1) ...[
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.topic.subTopics.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return GuideTopicTab(
                          label: widget.topic.subTopics[index].title,
                          isSelected: _selectedSubIndex == index,
                          onTap: () => setState(() => _selectedSubIndex = index),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                // Main Subtopic Details Card
                GuideSectionCard(
                  title: activeSub.title,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeSub.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      if (activeSub.steps.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Step-by-step instructions:',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activeSub.steps.length,
                          itemBuilder: (context, idx) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: widget.topic.color.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${idx + 1}',
                                        style: TextStyle(
                                          color: widget.topic.color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      activeSub.steps[idx],
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),

                if (activeSub.tip != null) ...[
                  const SizedBox(height: 14),
                  GuideInfoCard(
                    text: activeSub.tip!,
                    color: widget.topic.color,
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}