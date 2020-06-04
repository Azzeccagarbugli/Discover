import 'dart:math';

import 'package:Discover/main.dart';
import 'package:Discover/models/level.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/bar_graph.dart';
import 'package:Discover/ui/widgets/bar_line.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spring_button/spring_button.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class CurrentTrackView extends StatefulWidget {
  final int indexKey;

  const CurrentTrackView({
    Key key,
    this.indexKey,
  }) : super(key: key);

  @override
  _CurrentTrackViewState createState() => _CurrentTrackViewState();
}

class _CurrentTrackViewState extends State<CurrentTrackView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Track>(Discover.trackBoxName).listenable(),
          builder: (context, Box<Track> tracks, _) {
            return Row(
              children: <Widget>[
                NavigationRail(
                  elevation: 8,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  backgroundColor: ThemeProvider.themeOf(context)
                      .data
                      .scaffoldBackgroundColor,
                  groupAlignment: 0.0,
                  leading: Padding(
                    padding: const EdgeInsets.only(
                      top: 38,
                    ),
                    child: SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        height: 42,
                        width: 42,
                        decoration: new BoxDecoration(
                          color: ThemeProvider.themeOf(context)
                              .data
                              .scaffoldBackgroundColor,
                          shape: BoxShape.circle,
                          boxShadow: Neumorphism.boxShadow(context),
                        ),
                        child: Icon(
                          tracks.get(widget.indexKey).isSaved
                              ? (Icons.favorite)
                              : (Icons.favorite_border),
                          color:
                              ThemeProvider.themeOf(context).id == "light_theme"
                                  ? Colors.red[600]
                                  : Colors.white,
                        ),
                      ),
                      onTap: () {
                        Track nTrack = tracks.get(widget.indexKey).isSaved
                            ? new Track(
                                sound: tracks.get(widget.indexKey).sound,
                                date: tracks.get(widget.indexKey).date,
                                isSaved: false,
                              )
                            : new Track(
                                sound: tracks.get(widget.indexKey).sound,
                                date: tracks.get(widget.indexKey).date,
                                isSaved: true,
                              );

                        tracks.put(widget.indexKey, nTrack);
                      },
                      useCache: false,
                    ),
                  ),
                  labelType: NavigationRailLabelType.all,
                  selectedLabelTextStyle: ThemeProvider.themeOf(context)
                      .data
                      .primaryTextTheme
                      .headline6
                      .copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.6,
                      ),
                  unselectedLabelTextStyle: ThemeProvider.themeOf(context)
                      .data
                      .primaryTextTheme
                      .headline6
                      .copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.6,
                      ),
                  destinations: [
                    NavigationRailDestination(
                      icon: SizedBox.shrink(),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            "Cards".toUpperCase(),
                          ),
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: SizedBox.shrink(),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            "Graph".toUpperCase(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: ThemeProvider.themeOf(context).id == "light_theme"
                        ? Colors.white30
                        : Colors.black87,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        CardTrackInfo(
                          level: Level.HIGH,
                          track: tracks.get(widget.indexKey),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class CardTrackInfo extends StatelessWidget {
  final Track track;
  final Level level;

  const CardTrackInfo({
    Key key,
    this.track,
    this.level,
  }) : super(key: key);

  BorderRadius borderRadius() {
    return BorderRadius.horizontal(
      left: Radius.circular(
        25.0,
      ),
    );
  }

  double currentValue(Track track, Level level) {
    switch (level) {
      case Level.HIGH:
        return track.sound.reduce(max);
      case Level.MIN:
        return track.sound.reduce(min);
      case Level.AVG:
        return track.sound.reduce((a, b) => (a + b) / track.sound.length);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Container(
        decoration: new BoxDecoration(
          color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
          borderRadius: borderRadius(),
          boxShadow: Neumorphism.boxShadow(context),
          shape: BoxShape.rectangle,
        ),
        height: MediaQuery.of(context).size.height / 4,
        child: ClipRRect(
          borderRadius: borderRadius(),
          child: Stack(
            children: <Widget>[
              WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.red, Color(0xEEF44336)],
                    [Colors.red[800], Color(0x77E57373)],
                    [Colors.orange, Color(0x66FF9800)],
                    [Colors.yellow, Color(0x55FFEB3B)]
                  ],
                  durations: [35000, 19440, 10800, 6000],
                  heightPercentages: [0.10, 0.23, 0.25, 0.30],
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: ClipPath(
                  clipper: WaveClipperTwo(reverse: true),
                  child: Container(
                    height: 76,
                    color: Colors.orange,
                    child: Text(
                      currentValue(track, level).toStringAsFixed(0),
                      style: ThemeProvider.themeOf(context)
                          .data
                          .primaryTextTheme
                          .headline6
                          .copyWith(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height / 4,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CardWithGraph extends StatelessWidget {
//   const CardWithGraph({
//     Key key,
//     @required this.widget,
//   }) : super(key: key);

//   final CurrentTrackView widget;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               color:
//                   ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(24.0),
//               ),
//               boxShadow: Neumorphism.boxShadow(context),
//             ),
//           ),
//           Container(
//             color: Colors.transparent,
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 Expanded(
//                   flex: 2,
//                   child: CurvedListItem(
//                     title: 'MAX',
//                     color: Colors.red,
//                     nextColor: Colors.green,
//                     isFirst: true,
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: CurvedListItem(
//                     title: 'MIN',
//                     color: Colors.green,
//                     nextColor: Colors.amber,
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: CurvedListItem(
//                     title: 'AVG',
//                     color: Colors.amber,
//                     nextColor: ThemeProvider.themeOf(context)
//                         .data
//                         .scaffoldBackgroundColor,
//                   ),
//                 ),
//                 Expanded(
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: ThemeProvider.themeOf(context)
//                         .data
//                         .scaffoldBackgroundColor
//                         .withAlpha(32),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Text(
//                           'Continue',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_forward,
//                           color: Colors.white,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           FractionalTranslation(
//             translation: Offset(0.0, -0.45),
//             child: Align(
//               alignment: FractionalOffset(0.5, 0.45),
//               child: Container(
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 104,
//                 ),
//                 decoration: BoxDecoration(
//                   color: ThemeProvider.themeOf(context).id == "light_theme"
//                       ? Colors.white
//                       : Colors.grey[900],
//                   shape: BoxShape.circle,
//                   boxShadow: Neumorphism.boxShadow(context),
//                 ),
//                 child: CenterMedal(
//                   widget: widget,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CenterMedal extends StatelessWidget {
//   const CenterMedal({
//     Key key,
//     @required this.widget,
//   }) : super(key: key);

//   final CurrentTrackView widget;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Center(
//           child: AnimatedCircularChart(
//             size: Size(220, 220),
//             initialChartData: <CircularStackEntry>[
//               BarGraph.buildGraphMaxNoise(
//                   widget.track.sound.reduce(max), context),
//               BarGraph.buildGraphMinNoise(
//                   widget.track.sound.reduce(min), context),
//               BarGraph.buildGraphActualNoise(
//                   (widget.track.sound.reduce((a, b) => a + b) /
//                       widget.track.sound.length),
//                   context),
//             ],
//             chartType: CircularChartType.Radial,
//             edgeStyle: SegmentEdgeStyle.round,
//             percentageValues: true,
//             holeRadius: 18,
//             duration: Duration(
//               milliseconds: 700,
//             ),
//           ),
//         ),
//         Center(
//           child: Container(
//             margin: const EdgeInsets.all(72),
//             decoration: BoxDecoration(
//               color: ThemeProvider.themeOf(context).id == "light_theme"
//                   ? Colors.white
//                   : Colors.grey[900],
//               shape: BoxShape.circle,
//               boxShadow: Neumorphism.boxShadow(context),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: FlareActor(
//                 "assets/flares/recording.flr",
//                 fit: BoxFit.scaleDown,
//                 color: ThemeProvider.themeOf(context).data.accentColor,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class CurvedListItem extends StatelessWidget {
//   const CurvedListItem({
//     this.title,
//     this.time,
//     this.icon,
//     this.people,
//     this.color,
//     this.nextColor,
//     this.isFirst = false,
//   });

//   final String title;
//   final String time;
//   final String people;
//   final IconData icon;
//   final Color color;
//   final Color nextColor;
//   final bool isFirst;

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: isFirst
//           ? BorderRadius.only(
//               topLeft: Radius.circular(24.0),
//               topRight: Radius.circular(24.0),
//             )
//           : BorderRadius.zero,
//       child: Container(
//         width: double.infinity,
//         child: Container(
//           decoration: new BoxDecoration(
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(32.0),
//             ),
//           ),
//           child: Text(
//             title,
//             style: ThemeProvider.themeOf(context)
//                 .data
//                 .primaryTextTheme
//                 .headline6
//                 .copyWith(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 130,
//                   color: color,
//                 ),
//           ),
//         ),
//       ),
//     );
//   }
// }
