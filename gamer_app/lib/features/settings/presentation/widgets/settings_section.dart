import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.children,
  });

  static const Color sectionBg = Color(0xFF101012);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: sectionBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: children.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: Colors.white.withOpacity(0.05),
          indent: 72, // Aligns cleanly past the icon
        ),
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}