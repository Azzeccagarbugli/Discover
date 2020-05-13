import 'package:Discover/models/track.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class BuildLineGraph extends StatelessWidget {
  final Track trk;
  final bool enableTouch;

  const BuildLineGraph({@required this.trk, @required this.enableTouch});

  List<Color> gradientColors(BuildContext context) {
    return [
      ThemeProvider.themeOf(context).data.accentColor,
      ThemeProvider.themeOf(context).data.textSelectionColor,
    ];
  }

  List<FlSpot> _buildGraph(Track trk) {
    List<FlSpot> list = new List<FlSpot>();
    double i = 0;
    trk.sound.forEach((element) {
      list.add(FlSpot(i, num.parse(element.toStringAsFixed(3))));
      i++;
    });
    return list;
  }

  LineChartData mainData(BuildContext context) {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: trk.sound.length.toDouble() - 1,
      minY: 0,
      maxY: 100,
      lineTouchData: LineTouchData(
        enabled: enableTouch,
        touchTooltipData: LineTouchTooltipData(
          fitInsideVertically: true,
          tooltipRoundedRadius: 62,
          fitInsideHorizontally: true,
          tooltipBgColor: ThemeProvider.themeOf(context).data.accentColor,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                barSpot.y.toString(),
                ThemeProvider.themeOf(context)
                    .data
                    .primaryTextTheme
                    .subtitle1
                    .copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: _buildGraph(trk),
          isCurved: true,
          colors: gradientColors(context),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors(context)
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      mainData(context),
    );
  }
}
