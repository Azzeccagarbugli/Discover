import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:theme_provider/theme_provider.dart';

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
  static CircularStackEntry _buildGraphActualNoise(
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

  static CircularStackEntry _buildGraphMaxNoise(
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

  static CircularStackEntry _buildGraphMinNoise(
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

  void _cycleSamples(BuildContext context) {
    List<CircularStackEntry> nextData = <CircularStackEntry>[
      _buildGraphMaxNoise(widget.maxNoiseDB, context),
      _buildGraphMinNoise(widget.minNoiseDB, context),
      _buildGraphActualNoise(widget.noiseDB, context),
    ];
    setState(() {
      widget.chartKey.currentState.updateData(nextData);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isActive) _cycleSamples(context);
    return AnimatedCircularChart(
      key: widget.chartKey,
      size: Size(350, 350),
      initialChartData: <CircularStackEntry>[
        _buildGraphMaxNoise(widget.maxNoiseDB, context),
        _buildGraphMinNoise(widget.minNoiseDB, context),
        _buildGraphActualNoise(widget.noiseDB, context),
      ],
      chartType: CircularChartType.Radial,
      edgeStyle: SegmentEdgeStyle.round,
      percentageValues: true,
    );
  }
}
