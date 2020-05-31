import 'dart:math';

import 'package:Discover/main.dart';
import 'package:Discover/models/level.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/bar_line.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:Discover/ui/widgets/effects/remove_glow_listview.dart';
import 'package:Discover/ui/widgets/graph_tile_tracks.dart';
import 'package:Discover/ui/widgets/lateral_action.dart';
import 'package:Discover/ui/widgets/not_found.dart';
import 'package:Discover/ui/widgets/title_page.dart';
import 'package:Discover/ui/widgets/track_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listview_utils/listview_utils.dart';
import 'package:theme_provider/theme_provider.dart';

class TracksView extends StatefulWidget {
  @override
  _TracksViewState createState() => _TracksViewState();
}

class _TracksViewState extends State<TracksView> {
  final GlobalKey<AnimatedListState> _myList = GlobalKey<AnimatedListState>();

  Track _find(List<Track> tracks, Level level) {
    Track first = tracks.first;

    switch (level) {
      case Level.HIGH:
        tracks.forEach((element) {
          if (element.sound.reduce((a, b) => a + b) >
              first.sound.reduce((a, b) => a + b)) {
            first = element;
          }
        });
        break;
      case Level.MIN:
        tracks.forEach((element) {
          if (element.sound.reduce((a, b) => a + b) <
              first.sound.reduce((a, b) => a + b)) {
            first = element;
          }
        });
        break;
      case Level.AVG:
        tracks.forEach((element) {
          if ((element.sound.reduce((a, b) => a + b) / element.sound.length) >
              (first.sound.reduce((a, b) => a + b) / first.sound.length)) {
            first = element;
          }
        });
        break;
    }

    return first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.themeOf(context).id == "light_theme"
          ? Colors.white
          : Colors.grey[900],
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Track>(Discover.trackBoxName).listenable(),
        builder: (context, Box<Track> tracks, _) {
          if (tracks.isEmpty) {
            return NotFound(
              pathImg: ThemeProvider.themeOf(context).id == "light_theme"
                  ? "assets/images/tracks_light.png"
                  : "assets/images/tracks_dark.png",
              title: "No track found!",
              subtitile:
                  "If you would like to add a new track just go to the homepage and start to record a new session of sounds",
            );
          }

          List<Widget> _levels = [
            BuildTileHeaderTracks(
              trk: _find(tracks.values.toList(), Level.HIGH),
              msg: "LOUDEST",
            ),
            BuildTileHeaderTracks(
              trk: _find(tracks.values.toList(), Level.MIN),
              msg: "QUIETEST",
            ),
            BuildTileHeaderTracks(
              trk: _find(tracks.values.toList(), Level.AVG),
              msg: "BALANCED",
            ),
          ];

          return ScrollConfiguration(
            behavior: RemoveGlow(),
            child: CustomListView(
              key: _myList,
              disableRefresh: true,
              footer: SizedBox(
                height: 32,
              ),
              separatorBuilder: (_, index) => Divider(),
              itemCount: tracks.keys.cast<int>().toList().length,
              shrinkWrap: true,
              header: Container(
                child: tracks.length > 3
                    ? TitlePage(
                        useDecoration: false,
                        content: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 24,
                              ),
                              decoration: BoxDecoration(
                                color: ThemeProvider.themeOf(context)
                                    .data
                                    .scaffoldBackgroundColor,
                                boxShadow: Neumorphism.boxShadow(context),
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(25),
                                  right: Radius.circular(25),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(25),
                                  right: Radius.circular(25),
                                ),
                                child: _levels[index],
                              ),
                            );
                          },
                          itemCount: _levels.length,
                          viewportFraction: 0.7,
                          scale: 0.7,
                        ),
                      )
                    : TitlePage(
                        useDecoration: true,
                        content: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: Image.asset(
                                ThemeProvider.themeOf(context).id ==
                                        "light_theme"
                                    ? "assets/images/list_light.png"
                                    : "assets/images/list_dark.png",
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(25),
                                  right: Radius.circular(25),
                                ),
                                child: ClipPath(
                                  clipper: WaveClipperTwo(reverse: true),
                                  child: Container(
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: ThemeProvider.themeOf(context)
                                          .data
                                          .textSelectionColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            "Tracks",
                                            style: TextStyle(
                                              fontSize: 34,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Your sounds",
                                            style: TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                margin: const EdgeInsets.only(
                  top: 8,
                ),
                height: MediaQuery.of(context).size.height / 4,
              ),
              itemBuilder: (_, index, item) {
                int key =
                    tracks.keys.cast<int>().toList().reversed.toList()[index];

                Track trk = tracks.get(key);

                return Slidable(
                  key: Key(key.toString()),
                  actionPane: SlidableDrawerActionPane(),
                  showAllActionsThreshold: 0.5,
                  dismissal: SlidableDismissal(
                    child: SlidableDrawerDismissal(),
                    dismissThresholds: <SlideActionType, double>{
                      SlideActionType.secondary: 1.0
                    },
                    onDismissed: (actionType) {
                      setState(() {
                        tracks.delete(key);
                      });
                    },
                  ),
                  actions: <Widget>[
                    LateralAction(
                      closeOnTap: true,
                      icon: Icons.delete,
                      pos: key,
                      onTap: () {},
                      color: Colors.red,
                    ),
                  ],
                  secondaryActions: <Widget>[
                    LateralAction(
                      closeOnTap: false,
                      trk: trk,
                      pos: key,
                      onTap: () {
                        Track nTrack = new Track(
                          sound: trk.sound,
                          date: trk.date,
                          isSaved: !trk.isSaved,
                        );

                        tracks.put(key, nTrack);
                      },
                      color: Colors.green,
                      tracks: tracks,
                    ),
                    LateralAction(
                      closeOnTap: true,
                      icon: Icons.share,
                      pos: key,
                      onTap: () {},
                      color: Colors.blue[600],
                    ),
                  ],
                  child: TrackItemList(
                    trk: trk,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
