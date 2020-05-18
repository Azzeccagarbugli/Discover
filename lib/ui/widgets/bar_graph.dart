import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

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
          Colors.blueAccent.withOpacity(0.1),
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
          Colors.redAccent.withOpacity(0.1),
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
          Colors.greenAccent.withOpacity(0.1),
          rankKey: 'remaining',
        ),
      ],
      rankKey: 'progress',
    );
  }
}
