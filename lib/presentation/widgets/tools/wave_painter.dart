import 'dart:math' as math;

import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final double animation;
  final Color color;
  final bool isBackWave;

  WavePainter({
    required this.animation,
    required this.color,
    required this.isBackWave,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      final x = i;
      // Create a smooth, minimalist wave pattern with synchronized frequencies
      final y = size.height * 0.5 +
          // Main wave with synchronized frequency
          math.sin((i / size.width * 2 * math.pi) + animation) * 16 +
          // Secondary wave with synchronized frequency
          math.sin((i / size.width * 2 * math.pi) + animation * 2) * 8;

      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
} 