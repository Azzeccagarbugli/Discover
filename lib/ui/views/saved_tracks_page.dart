import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/views/track_page.dart';
import 'package:Discover/ui/widgets/effects/remove_glow_listview.dart';
import 'package:Discover/ui/widgets/not_found.dart';
import 'package:Discover/ui/widgets/saved_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CurrentTrackView(
                            indexKey: tracks.keys
                                .cast<int>()
                                .where((elem) => tracks.get(elem).isSaved)
                                .toList()
                                .reversed
                                .toList()[index],
                          ),
                        ),
                      );
                    },
                    child: SavedItem(
                      trk: trk,
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
