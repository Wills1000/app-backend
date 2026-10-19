import 'package:flutter/material.dart';

class GuideSubTopic {
  final String id;
  final String title;
  final String description;
  final List<String> steps;
  final String? tip;

  const GuideSubTopic({
    required this.id,
    required this.title,
    required this.description,
    this.steps = const [],
    this.tip,
  });
}

class GuideTopicModel {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<GuideSubTopic> subTopics;

  const GuideTopicModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.subTopics,
  });
}