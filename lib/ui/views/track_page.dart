import 'dart:math';

import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/bar_graph.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:theme_provider/theme_provider.dart';

class CurrentTrackView extends StatefulWidget {
  final Track track;

  const CurrentTrackView({
    Key key,
    @required this.track,
  }) : super(key: key);

  @override
  _CurrentTrackViewState createState() => _CurrentTrackViewState();
}

class _CurrentTrackViewState extends State<CurrentTrackView> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 10,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3,
            child: LineChart(
              mainData(),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.5),
            child: CardWithGraph(
              widget: widget,
            ),
          ),
        ],
      ),
    );
  }
}

class CardWithGraph extends StatelessWidget {
  const CardWithGraph({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final CurrentTrackView widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color:
                  ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              boxShadow: Neumorphism.boxShadow(context),
            ),
          ),
          FractionalTranslation(
            translation: Offset(0.0, -0.4),
            child: Align(
              alignment: FractionalOffset(0.5, 0.4),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 92,
                ),
                decoration: BoxDecoration(
                  color: ThemeProvider.themeOf(context).id == "light_theme"
                      ? Colors.white
                      : Colors.grey[900],
                  shape: BoxShape.circle,
                  boxShadow: Neumorphism.boxShadow(context),
                ),
                child: AnimatedCircularChart(
                  size: Size(280, 280),
                  holeRadius: 3,
                  initialChartData: <CircularStackEntry>[
                    BarGraph.buildGraphMaxNoise(
                        widget.track.sound.reduce(max), context),
                    BarGraph.buildGraphMinNoise(
                        widget.track.sound.reduce(min), context),
                    BarGraph.buildGraphActualNoise(
                        (widget.track.sound.reduce((a, b) => a + b) /
                            widget.track.sound.length),
                        context),
                  ],
                  chartType: CircularChartType.Radial,
                  edgeStyle: SegmentEdgeStyle.round,
                  percentageValues: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
