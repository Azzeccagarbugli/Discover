import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
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
              final int key = tracks.keys.cast<int>().toList()[index];

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
                  Container(
                    margin: EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      child: IconSlideAction(
                        closeOnTap: true,
                        caption: 'Delete',
                        icon: Icons.delete,
                        color: Colors.red,
                        onTap: () => {},
                      ),
                    ),
                  ),
                ],
                secondaryActions: <Widget>[
                  Container(
                    margin: EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      child: IconSlideAction(
                        caption: trk.isSaved ? 'Unsave' : 'Save',
                        icon: trk.isSaved
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.green,
                        onTap: () {
                          Track nTrack = new Track(
                            sound: trk.sound,
                            date: trk.date,
                            isSaved: true,
                          );

                          tracks.put(key, nTrack);
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      child: IconSlideAction(
                        caption: 'Share',
                        icon: Icons.share,
                        color: Colors.indigoAccent,
                        onTap: () => {},
                      ),
                    ),
                  ),
                ],
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  color: Colors.indigo,
                  child: ListTile(
                    title: Text(trk.date),
                    subtitle: Text(trk.sound.toString()),
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
