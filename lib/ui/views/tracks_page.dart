import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TracksView extends StatefulWidget {
  @override
  _TracksViewState createState() => _TracksViewState();
}

class _TracksViewState extends State<TracksView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Track>(Discover.trackBoxName).listenable(),
          builder: (context, Box<Track> tracks, _) {
            print("CIAO");

            return ListView.separated(
              itemBuilder: (_, index) {
                final int key = tracks.keys.cast<int>().toList()[index];

                final Track trk = tracks.get(key);

                return Card(
                  color: Colors.indigo,
                  child: ListTile(
                    title: Text(trk.date),
                    subtitle: Text(trk.sound.toString()),
                    trailing: Icon(
                      trk.isSaved ? Icons.favorite : Icons.favorite_border,
                      color: trk.isSaved ? Colors.red : Colors.grey,
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) {
                return Divider();
              },
              itemCount: tracks.keys.cast<int>().toList().length,
            );
          },
        ),
      ),
    );
  }
}
