import 'dart:math';

import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/bar_graph.dart';
import 'package:Discover/ui/widgets/bar_line.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flare_flutter/flare_actor.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3,
            child: BuildLineGraph(
              trk: widget.track,
              enableTouch: true,
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
            decoration: BoxDecoration(
              color:
                  ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24.0),
              ),
              boxShadow: Neumorphism.boxShadow(context),
            ),
          ),
          Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: CurvedListItem(
                    title: 'MAX',
                    color: Colors.red,
                    nextColor: Colors.green,
                    isFirst: true,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: CurvedListItem(
                    title: 'MIN',
                    color: Colors.green,
                    nextColor: Colors.amber,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: CurvedListItem(
                    title: 'AVG',
                    color: Colors.amber,
                    nextColor: ThemeProvider.themeOf(context)
                        .data
                        .scaffoldBackgroundColor,
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {},
                    color: ThemeProvider.themeOf(context)
                        .data
                        .scaffoldBackgroundColor
                        .withAlpha(32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          FractionalTranslation(
            translation: Offset(0.0, -0.45),
            child: Align(
              alignment: FractionalOffset(0.5, 0.45),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 104,
                ),
                decoration: BoxDecoration(
                  color: ThemeProvider.themeOf(context).id == "light_theme"
                      ? Colors.white
                      : Colors.grey[900],
                  shape: BoxShape.circle,
                  boxShadow: Neumorphism.boxShadow(context),
                ),
                child: CenterMedal(
                  widget: widget,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CenterMedal extends StatelessWidget {
  const CenterMedal({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final CurrentTrackView widget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: AnimatedCircularChart(
            size: Size(220, 220),
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
            holeRadius: 18,
            duration: Duration(
              milliseconds: 700,
            ),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.all(72),
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? Colors.white
                  : Colors.grey[900],
              shape: BoxShape.circle,
              boxShadow: Neumorphism.boxShadow(context),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: widget.track.date,
                child: FlareActor(
                  "assets/flares/recording.flr",
                  fit: BoxFit.scaleDown,
                  color: ThemeProvider.themeOf(context).data.accentColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CurvedListItem extends StatelessWidget {
  const CurvedListItem({
    this.title,
    this.time,
    this.icon,
    this.people,
    this.color,
    this.nextColor,
    this.isFirst = false,
  });

  final String title;
  final String time;
  final String people;
  final IconData icon;
  final Color color;
  final Color nextColor;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: isFirst
          ? BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            )
          : BorderRadius.zero,
      child: Container(
        width: double.infinity,
        child: Container(
          decoration: new BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
            ),
          ),
          child: Text(
            title,
            style: ThemeProvider.themeOf(context)
                .data
                .primaryTextTheme
                .headline6
                .copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 130,
                  color: color,
                ),
          ),
        ),
      ),
    );
  }
}
