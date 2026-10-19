import 'dart:math' as math;
import 'package:flutter/material.dart';

class SegmentedStatusRing extends StatelessWidget {
  final String avatarUrl;
  final int totalCount;
  final int viewedCount;
  final bool isOnline;
  final double radius;
  final VoidCallback onTap;

  const SegmentedStatusRing({
    super.key,
    required this.avatarUrl,
    required this.totalCount,
    required this.viewedCount,
    required this.onTap,
    this.isOnline = false,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CustomPaint(
            painter: _RingPainter(
              totalCount: totalCount,
              viewedCount: viewedCount,
            ),
            child: Container(
              padding: const EdgeInsets.all(3),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: const Color(0xff222228),
                backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
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
    );
  }
}

class _RingPainter extends CustomPainter {
  final int totalCount;
  final int viewedCount;

  _RingPainter({required this.totalCount, required this.viewedCount});

  @override
  void paint(Canvas canvas, Size size) {
    if (totalCount <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 2.5;
    final radius = (size.width - strokeWidth) / 2;

    final redPaint = Paint()
      ..color = const Color(0xffE50914)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final grayPaint = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (totalCount == 1) {
      canvas.drawCircle(center, radius, viewedCount >= 1 ? grayPaint : redPaint);
      return;
    }

    const double gapAngle = 0.18;
    final double segmentAngle = (2 * math.pi - (totalCount * gapAngle)) / totalCount;
    double startAngle = -math.pi / 2;

    for (int i = 0; i < totalCount; i++) {
      final paint = i < viewedCount ? grayPaint : redPaint;
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
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.totalCount != totalCount || oldDelegate.viewedCount != viewedCount;
}