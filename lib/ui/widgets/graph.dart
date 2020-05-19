import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'bar_graph.dart';

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
  void _cycleSamples(BuildContext context) {
    List<CircularStackEntry> nextData = <CircularStackEntry>[
      BarGraph.buildGraphMaxNoise(widget.maxNoiseDB, context),
      BarGraph.buildGraphMinNoise(widget.minNoiseDB, context),
      BarGraph.buildGraphActualNoise(widget.noiseDB, context),
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
      size: MediaQuery.of(context).size,
      initialChartData: <CircularStackEntry>[
        BarGraph.buildGraphMaxNoise(widget.maxNoiseDB, context),
        BarGraph.buildGraphMinNoise(widget.minNoiseDB, context),
        BarGraph.buildGraphActualNoise(widget.noiseDB, context),
      ],
      chartType: CircularChartType.Radial,
      edgeStyle: SegmentEdgeStyle.round,
      percentageValues: true,
    );
  }
}
