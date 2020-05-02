import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/lateral_action.dart';
import 'package:Discover/ui/widgets/track_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
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
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                color: Colors.blue[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Image.asset(
                              "assets/images/tracks.png",
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Tracks",
                                  style: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryTextTheme
                                      .title
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 42,
                                      ),
                                ),
                                Text(
                                  "Feel what \nyou lived",
                                  style: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryTextTheme
                                      .body1
                                      .copyWith(
                                        fontSize: 26,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<Track>(Discover.trackBoxName).listenable(),
              builder: (context, Box<Track> tracks, _) {
                return ListView.separated(
                  key: _myList,
                  separatorBuilder: (_, index) => Divider(),
                  itemCount: tracks.keys.cast<int>().toList().length,
                  itemBuilder: (_, index) {
                    final int key = tracks.keys
                        .cast<int>()
                        .toList()
                        .reversed
                        .toList()[index];

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
                          tracks.delete(key);
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
                          color: Colors.indigoAccent,
                        ),
                      ],
                      child: TrackItemList(
                        trk: trk,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
