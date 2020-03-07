import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;

  const AnimatedWave({
    this.height,
    this.speed,
    this.offset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: ControlledAnimation(
          playback: Playback.LOOP,
          duration: Duration(milliseconds: (5000 / speed).round()),
          tween: Tween(begin: 0.0, end: 2 * pi),
          builder: (context, value) {
            return CustomPaint(
              foregroundPainter: CurvePainter(value + offset),
            );
          },
        ),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.blue[400].withAlpha(50)
      ..strokeWidth = 4;

    var stepSize = pi * 0.05;

    final heightScale = 0.3;
    for (var x = 0 * pi; x <= 2 * pi; x += stepSize) {
      final p1 = Offset((x - stepSize) / (2 * pi) * size.width,
          sin(x - stepSize + value) * heightScale * size.height);
      final p2 = Offset(x / (2 * pi) * size.width,
          sin(x + value) * heightScale * size.height);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
