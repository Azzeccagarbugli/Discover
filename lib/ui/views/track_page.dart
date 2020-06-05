import 'package:Discover/main.dart';
import 'package:Discover/models/level.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/bar_line.dart';
import 'package:Discover/ui/widgets/card_info_db.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spring_button/spring_button.dart';
import 'package:theme_provider/theme_provider.dart';

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
                  groupAlignment: -0.4,
                  leading: Column(
                    children: <Widget>[
                      Padding(
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
                              color: ThemeProvider.themeOf(context)
                                  .data
                                  .buttonColor,
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
                      Padding(
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
                              Icons.share,
                              color: ThemeProvider.themeOf(context)
                                  .data
                                  .primaryTextTheme
                                  .headline6
                                  .color,
                            ),
                          ),
                          onTap: () {},
                          useCache: true,
                        ),
                      ),
                    ],
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

  List<Widget> buildColumnValues() {
    List<Widget> list = new List<Widget>();

    Widget buildItem(int x) {
      switch (x) {
        case 0:
          return Icon(
            Icons.looks_one,
            color: ThemeProvider.themeOf(context)
                .data
                .primaryTextTheme
                .headline6
                .color,
          );
        case 2:
          return Icon(
            Icons.looks_two,
            color: ThemeProvider.themeOf(context)
                .data
                .primaryTextTheme
                .headline6
                .color,
          );
        case 4:
          return Icon(
            Icons.looks_3,
            color: ThemeProvider.themeOf(context)
                .data
                .primaryTextTheme
                .headline6
                .color,
          );
        case 6:
          return Icon(
            Icons.looks_4,
            color: ThemeProvider.themeOf(context)
                .data
                .primaryTextTheme
                .headline6
                .color,
          );
        case 8:
          return Icon(
            Icons.looks_5,
            color: ThemeProvider.themeOf(context)
                .data
                .primaryTextTheme
                .headline6
                .color,
          );
        default:
          return Text(
            "•",
            style:
                ThemeProvider.themeOf(context).data.primaryTextTheme.headline6,
          );
      }
    }

    for (var i = 0; i < 10; i++) {
      list.add(buildItem(i));
    }

    return list.reversed.toList();
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: buildColumnValues(),
                    ),
                  ),
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
