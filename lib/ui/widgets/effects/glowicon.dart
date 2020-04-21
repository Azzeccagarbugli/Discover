import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class GlowIconRecording extends StatelessWidget {
  final Color color;

  GlowIconRecording({@required this.color});

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: color,
      endRadius: 10.0,
      repeat: true,
      shape: BoxShape.circle,
      animate: true,
      curve: Curves.fastOutSlowIn,
      showTwoGlows: true,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: Material(
        color: Colors.transparent,
        child: Icon(
          Icons.brightness_1,
          color: color.withAlpha(222),
          size: 12,
        ),
      ),
    );
  }
}
