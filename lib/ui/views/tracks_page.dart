import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/bar_line.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:Discover/ui/widgets/effects/remove_glow_listview.dart';
import 'package:Discover/ui/widgets/lateral_action.dart';
import 'package:Discover/ui/widgets/not_found.dart';
import 'package:Discover/ui/widgets/saved_item.dart';
import 'package:Discover/ui/widgets/title_page.dart';
import 'package:Discover/ui/widgets/track_item_list.dart';
import 'package:flutter/material.dart';
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

          List c = [
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.orange,
            ),
            Container(
              color: Colors.green,
            ),
          ];

          return ScrollConfiguration(
            behavior: RemoveGlow(),
            child: CustomListView(
              key: _myList,
              separatorBuilder: (_, index) => Divider(),
              itemCount: tracks.keys.cast<int>().toList().length,
              shrinkWrap: true,
              header: Container(
                child: TitlePage(
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
                          child: Stack(
                            children: <Widget>[
                              // BuildLineGraph(
                              //   trk: tracks.get(
                              //       tracks.keys.cast<int>().toList()[index]),
                              //   enableTouch: false,
                              // ),
                              c[index],
                              Positioned(
                                bottom: -18,
                                left: 0,
                                child: Text(
                                  "MAX",
                                  style: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryTextTheme
                                      .headline6
                                      .copyWith(
                                        fontSize: 62,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: c.length,
                    viewportFraction: 0.7,
                    scale: 0.7,
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
