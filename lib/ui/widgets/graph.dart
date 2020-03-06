import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class MainGraph extends StatefulWidget {
  final GlobalKey<AnimatedCircularChartState> chartKey;
  final double maxNoiseDB;
  final double minNoiseDB;
  final double noiseDB;
  final bool isActive;

  MainGraph({
    @required this.chartKey,
    @required this.maxNoiseDB,
    @required this.minNoiseDB,
    @required this.noiseDB,
    @required this.isActive,
  });

  @override
  _MainGraphState createState() => _MainGraphState();
}

class _MainGraphState extends State<MainGraph> {
  static CircularStackEntry _buildGraphActualNoise(double value) {
    return CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(
          value,
          Colors.blue[800],
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          (100 - value),
          Colors.blue[50],
          rankKey: 'remaining',
        ),
      ],
      rankKey: 'progress',
    );
  }

  static CircularStackEntry _buildGraphMaxNoise(double value) {
    return CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(
          value,
          Colors.red,
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          (100 - value),
          Colors.red[50],
          rankKey: 'remaining',
        ),
      ],
      rankKey: 'progress',
    );
  }

  static CircularStackEntry _buildGraphMinNoise(double value) {
    return CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(
          value,
          Colors.green[300],
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          (100 - value),
          Colors.green[50],
          rankKey: 'remaining',
        ),
      ],
      rankKey: 'progress',
    );
  }

  void _cycleSamples() {
    List<CircularStackEntry> nextData = <CircularStackEntry>[
      _buildGraphMaxNoise(widget.maxNoiseDB),
      _buildGraphMinNoise(widget.minNoiseDB),
      _buildGraphActualNoise(widget.noiseDB),
    ];
    setState(() {
      widget.chartKey.currentState.updateData(nextData);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isActive) _cycleSamples();
    return AnimatedCircularChart(
      key: widget.chartKey,
      size: Size(350, 350),
      initialChartData: <CircularStackEntry>[
        _buildGraphMaxNoise(widget.maxNoiseDB),
        _buildGraphMinNoise(widget.minNoiseDB),
        _buildGraphActualNoise(widget.noiseDB),
      ],
      chartType: CircularChartType.Radial,
      edgeStyle: SegmentEdgeStyle.round,
      percentageValues: true,
    );
  }
}
