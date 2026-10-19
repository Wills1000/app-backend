import 'dart:math' as math;
import 'package:flutter/material.dart';

class StoryAvatar extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final bool isOnline;
  final bool isNewChatButton;
  final int statusCount;
  final int viewedCount;
  final VoidCallback? onTap;

  const StoryAvatar({
    super.key,
    required this.avatarUrl,
    required this.name,
    this.isOnline = true,
    this.isNewChatButton = false,
    this.statusCount = 1,
    this.viewedCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // --- 1. NEW STATUS / ADD BUTTON ---
    if (isNewChatButton) {
      return Padding(
        padding: const EdgeInsets.only(right: 14.0),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xff141416),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xff222226), width: 1.5),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 6),
              const Text(
                'New Status',
                style: TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
        ),
      );
    }

    // --- 2. USER STATUS AVATAR WITH SEGMENTED RING ---
    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Stack(
              children: [
                CustomPaint(
                  painter: _SegmentedStatusPainter(
                    totalCount: statusCount,
                    viewedCount: viewedCount,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(avatarUrl),
                      backgroundColor: const Color(0xff222226),
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xff00FF66),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 58,
              child: Text(
                name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SEGMENTED STATUS RING PAINTER ---
class _SegmentedStatusPainter extends CustomPainter {
  final int totalCount;
  final int viewedCount;

  _SegmentedStatusPainter({
    required this.totalCount,
    required this.viewedCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (totalCount <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 2.0;
    final radius = (size.width - strokeWidth) / 2;

    final Paint unviewedPaint = Paint()
      ..color = const Color(0xffE50914) // Red for unviewed
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint viewedPaint = Paint()
      ..color = Colors.grey.shade700 // Gray for viewed
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Single status item: Draw a full circle
    if (totalCount == 1) {
      canvas.drawCircle(
        center,
        radius,
        viewedCount >= 1 ? viewedPaint : unviewedPaint,
      );
      return;
    }

    // Multiple status items: Divide into segmented arcs with gaps
    const double gapAngle = 0.18; // Gap spacing in radians
    final double totalGaps = totalCount * gapAngle;
    final double segmentAngle = (2 * math.pi - totalGaps) / totalCount;

    double startAngle = -math.pi / 2; // Start from top center

    for (int i = 0; i < totalCount; i++) {
      final bool isSegmentViewed = i < viewedCount;
      final paint = isSegmentViewed ? viewedPaint : unviewedPaint;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        false,
        paint,
      );

      startAngle += segmentAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentedStatusPainter oldDelegate) {
    return oldDelegate.totalCount != totalCount ||
        oldDelegate.viewedCount != viewedCount;
  }
}