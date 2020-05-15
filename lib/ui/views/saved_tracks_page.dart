import 'dart:math';
import 'dart:ui';

import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/bar_line.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:Discover/ui/widgets/effects/remove_glow_listview.dart';
import 'package:Discover/ui/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

class SavedTracksView extends StatefulWidget {
  @override
  _SavedTracksViewState createState() => _SavedTracksViewState();
}

class _SavedTracksViewState extends State<SavedTracksView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.themeOf(context).id == "light_theme"
          ? Colors.white
          : Colors.grey[900],
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Track>(Discover.trackBoxName).listenable(),
        builder: (context, Box<Track> tracks, _) {
          if (tracks.keys.where((elem) => tracks.get(elem).isSaved).isEmpty) {
            return NotFound(
              pathImg: ThemeProvider.themeOf(context).id == "light_theme"
                  ? "assets/images/saved_light.png"
                  : "assets/images/saved_dark.png",
              title: "No saved track yet!",
              subtitile:
                  "If you would like to save a new track just go to the tracks page and save one of them by swiping laterally on it",
            );
          }

          return ScrollConfiguration(
            behavior: RemoveGlow(),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                final int key = tracks.keys
                    .cast<int>()
                    .where((elem) => tracks.get(elem).isSaved)
                    .toList()
                    .reversed
                    .toList()[index];

                final Track trk = tracks.get(key);
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 6,
                    top: 48,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeProvider.themeOf(context)
                          .data
                          .scaffoldBackgroundColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(36.0),
                      ),
                      boxShadow: Neumorphism.boxShadow(context),
                    ),
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(36),
                          ),
                          child: ClipPath(
                            clipper: OvalBottomBorderClipper(),
                            child: Container(
                              color: ThemeProvider.themeOf(context)
                                  .data
                                  .scaffoldBackgroundColor,
                              height: MediaQuery.of(context).size.height / 1.6,
                              width: double.infinity,
                              child: BuildLineGraph(
                                trk: trk,
                                enableTouch: false,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 22,
                          right: 22,
                          left: 22,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: 52,
                                width: 52,
                                decoration: BoxDecoration(
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .scaffoldBackgroundColor,
                                  shape: BoxShape.circle,
                                  boxShadow: Neumorphism.boxShadow(context),
                                ),
                                child: Icon(
                                  Icons.share,
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 1.85,
                          right: 16,
                          left: 16,
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: ThemeProvider.themeOf(context)
                                  .data
                                  .scaffoldBackgroundColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(36.0),
                              ),
                              boxShadow: Neumorphism.boxShadow(context),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ValueBuilding(
                                  value: trk.sound.reduce(min),
                                  desc: "MIN",
                                  color: Colors.green,
                                ),
                                ValueBuilding(
                                  value: trk.sound.reduce((a, b) => a + b) /
                                      trk.sound.length,
                                  desc: "AVG",
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .accentColor,
                                ),
                                ValueBuilding(
                                  value: trk.sound.reduce(max),
                                  desc: "MAX",
                                  color: Colors.red[300],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 22,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                DateFormat('EEEE, MMM d').format(trk.date),
                                style: ThemeProvider.themeOf(context)
                                    .data
                                    .primaryTextTheme
                                    .bodyText1
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                    ),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Recorded at ' +
                                    DateFormat('hh:mm a').format(trk.date),
                                style: ThemeProvider.themeOf(context)
                                    .data
                                    .primaryTextTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: 22,
                                    ),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: tracks.keys
                  .cast<int>()
                  .where((elem) => tracks.get(elem).isSaved)
                  .toList()
                  .length,
              viewportFraction: 0.8,
              scale: 0.9,
              loop: false,
            ),
          );
        },
      ),
    );
  }
}

class ValueBuilding extends StatelessWidget {
  final double value;
  final String desc;
  final Color color;

  const ValueBuilding({
    @required this.value,
    @required this.desc,
    @required this.color,
  });

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          value.toStringAsFixed(0),
          style: ThemeProvider.themeOf(context)
              .data
              .primaryTextTheme
              .bodyText1
              .copyWith(
                color: ThemeProvider.themeOf(context).id == "dark_theme"
                    ? Colors.grey[300]
                    : darken(color),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          desc,
          style: ThemeProvider.themeOf(context)
              .data
              .primaryTextTheme
              .bodyText1
              .copyWith(
                color: ThemeProvider.themeOf(context).id == "dark_theme"
                    ? Colors.grey[400]
                    : color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
