import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:theme_provider/theme_provider.dart';

class BarGraph {
  static CircularStackEntry buildGraphActualNoise(
      double value, BuildContext context) {
    return CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(
          value,
          Colors.blue[800],
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          (100 - value),
          ThemeProvider.themeOf(context).id == "light_theme"
              ? Colors.blue[50]
              : Colors.blueAccent.withOpacity(0.2),
          rankKey: 'remaining',
        ),
      ],
      rankKey: 'progress',
    );
  }

  static CircularStackEntry buildGraphMaxNoise(
      double value, BuildContext context) {
    return CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(
          value,
          Colors.red,
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          (100 - value),
          ThemeProvider.themeOf(context).id == "light_theme"
              ? Colors.red[50]
              : Colors.redAccent.withOpacity(0.2),
          rankKey: 'remaining',
        ),
      ],
      rankKey: 'progress',
    );
  }

  static CircularStackEntry buildGraphMinNoise(
      double value, BuildContext context) {
    return CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(
          value,
          Colors.green[300],
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          (100 - value),
          ThemeProvider.themeOf(context).id == "light_theme"
              ? Colors.green[50]
              : Colors.greenAccent.withOpacity(0.2),
          rankKey: 'remaining',
        ),
      ],
      rankKey: 'progress',
    );
  }
}
