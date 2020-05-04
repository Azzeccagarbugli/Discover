import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/effects/remove_glow_listview.dart';
import 'package:Discover/ui/widgets/lateral_action.dart';
import 'package:Discover/ui/widgets/not_found.dart';
import 'package:Discover/ui/widgets/track_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:theme_provider/theme_provider.dart';

class TracksView extends StatefulWidget {
  @override
  _TracksViewState createState() => _TracksViewState();
}

class _TracksViewState extends State<TracksView> {
  final GlobalKey<AnimatedListState> _myList = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.themeOf(context).id == "light_theme"
          ? Colors.white
          : Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Track>(Discover.trackBoxName).listenable(),
          builder: (context, Box<Track> tracks, _) {
            if (tracks.isEmpty) {
              return NotFound(
                pathImg: ThemeProvider.themeOf(context).id == "light_theme"
                    ? "assets/images/tracks_light.png"
                    : "assets/images/tracks_dark.png",
                title: "Any track found!",
                subtitile:
                    "If you would like to add a new track just go to the homepage and start to record a new session of sounds",
              );
            }

            return ScrollConfiguration(
              behavior: RemoveGlow(),
              child: ListView.separated(
                key: _myList,
                separatorBuilder: (_, index) => Divider(),
                itemCount: tracks.keys.cast<int>().toList().length,
                itemBuilder: (_, index) {
                  final int key =
                      tracks.keys.cast<int>().toList().reversed.toList()[index];

                  final Track trk = tracks.get(key);

                  return Slidable(
                    key: Key(key.toString()),
                    actionPane: SlidableDrawerActionPane(),
                    closeOnScroll: true,
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
      ),
    );
  }
}
