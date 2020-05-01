import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:Discover/ui/widgets/lateral_action.dart';
import 'package:flare_flutter/flare_actor.dart';
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
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Track>(Discover.trackBoxName).listenable(),
        builder: (context, Box<Track> tracks, _) {
          return ListView.separated(
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
                  onDismissed: (actionType) {
                    tracks.delete(key);
                  },
                ),
                actions: <Widget>[
                  LateralAction(
                    closeOnTap: true,
                    caption: "Delete",
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
                    caption: "Share",
                    icon: Icons.share,
                    pos: key,
                    onTap: () {},
                    color: Colors.indigoAccent,
                  ),
                ],
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: new BoxDecoration(
                    color: ThemeProvider.themeOf(context)
                        .data
                        .scaffoldBackgroundColor,
                    boxShadow: Neumorphism.boxShadow(context),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      trk.date,
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "BELLA",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    leading: Container(
                      height: 42,
                      width: 42,
                      padding: const EdgeInsets.all(6),
                      decoration: new BoxDecoration(
                        color: ThemeProvider.themeOf(context)
                            .data
                            .scaffoldBackgroundColor,
                        boxShadow: Neumorphism.boxShadow(context),
                        shape: BoxShape.circle,
                      ),
                      child: FlareActor(
                        "assets/flares/recording.flr",
                        fit: BoxFit.contain,
                        color: Colors.green[400],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
