import 'dart:math';

import 'package:Discover/main.dart';
import 'package:Discover/models/level.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/bar_line.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:flutter/material.dart';
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
                  elevation: 12,
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
                buildValueNav(context, tracks, _selectedIndex),
              ],
            );
          }),
    );
  }

  Widget buildValueNav(BuildContext context, Box<Track> tracks, int i) {
    switch (i) {
      case 0:
        return Expanded(
          child: Container(
            color: ThemeProvider.themeOf(context).id == "light_theme"
                ? Colors.white30
                : Colors.black87,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CardTrackInfo(
                  level: Level.HIGH,
                  track: tracks.get(widget.indexKey),
                ),
                CardTrackInfo(
                  level: Level.AVG,
                  track: tracks.get(widget.indexKey),
                ),
                CardTrackInfo(
                  level: Level.MIN,
                  track: tracks.get(widget.indexKey),
                ),
              ],
            ),
          ),
        );
      case 1:
        return Expanded(
          child: Container(
            height: double.infinity,
            color: ThemeProvider.themeOf(context).id == "light_theme"
                ? Colors.white30
                : Colors.black87,
            child: Row(
              children: <Widget>[
                Container(
                  color: ThemeProvider.themeOf(context).id == "light_theme"
                      ? Colors.white30
                      : Colors.grey[850],
                  width: 30,
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    child: BuildLineGraph(
                      trk: tracks.get(widget.indexKey),
                      enableTouch: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return null;
    }
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
        return track.sound.reduce((a, b) => a + b) / track.sound.length;
      default:
        return null;
    }
  }

  List<List<Color>> gradients(Level level, BuildContext context) {
    switch (level) {
      case Level.HIGH:
        return [
          [Colors.red, Color(0xEEF44336)],
          [Colors.red[800], Color(0x77E57373)],
          [Colors.orange, Color(0x66FF9800)],
          [Colors.redAccent[400], Colors.redAccent]
        ];
      case Level.MIN:
        return [
          [Colors.green[200], Colors.green[300]],
          [Colors.green[800], Colors.green[700]],
          [Colors.green[700], Colors.green[900]],
          [Colors.greenAccent, Colors.greenAccent[700]],
        ];
      case Level.AVG:
        return [
          [
            ThemeProvider.themeOf(context).data.accentColor,
            ThemeProvider.themeOf(context).data.accentColor,
          ],
          [
            ThemeProvider.themeOf(context).data.primaryColor.withOpacity(0.2),
            ThemeProvider.themeOf(context).data.primaryColor.withOpacity(0.2),
          ],
          [
            ThemeProvider.themeOf(context).data.textSelectionColor,
            ThemeProvider.themeOf(context).data.textSelectionColor
          ],
          [
            ThemeProvider.themeOf(context).data.accentColor.withOpacity(0.2),
            ThemeProvider.themeOf(context).data.accentColor.withOpacity(0.2),
          ]
        ];
      default:
        return null;
    }
  }

  List<int> durationLevel(Level level) {
    switch (level) {
      case Level.HIGH:
        return [35000, 19440, 10800, 6000];
      case Level.MIN:
        return [20000, 17200, 5900, 4000];
      case Level.AVG:
        return [14000, 11440, 8800, 18800];
      default:
        return null;
    }
  }

  Color colorLevel(Level level, BuildContext context) {
    switch (level) {
      case Level.HIGH:
        return Colors.red[600];
      case Level.MIN:
        return Colors.green;
      case Level.AVG:
        return ThemeProvider.themeOf(context).data.accentColor;
      default:
        return null;
    }
  }

  IconData iconsLevel(Level level) {
    switch (level) {
      case Level.HIGH:
        return Icons.trending_up;
      case Level.MIN:
        return Icons.trending_down;
      case Level.AVG:
        return Icons.trending_flat;
      default:
        return null;
    }
  }

  String msgLevel(Level level) {
    switch (level) {
      case Level.HIGH:
        return "MAX";
      case Level.MIN:
        return "MIN";
      case Level.AVG:
        return "AVG";
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
                  gradients: gradients(level, context),
                  durations: durationLevel(level),
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
                    height: 96,
                    color: colorLevel(level, context),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            currentValue(track, level).toStringAsFixed(0),
                            style: ThemeProvider.themeOf(context)
                                .data
                                .primaryTextTheme
                                .headline6
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 62,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            "db",
                            style: ThemeProvider.themeOf(context)
                                .data
                                .primaryTextTheme
                                .headline6
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 22,
                bottom: 22,
                child: Chip(
                  elevation: 8,
                  backgroundColor: ThemeProvider.themeOf(context)
                      .data
                      .scaffoldBackgroundColor,
                  avatar: CircleAvatar(
                    backgroundColor: colorLevel(level, context),
                    child: Icon(
                      iconsLevel(level),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  label: Text(
                    msgLevel(level),
                    style: ThemeProvider.themeOf(context)
                        .data
                        .primaryTextTheme
                        .headline6
                        .copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
