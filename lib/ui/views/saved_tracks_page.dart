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
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Track>(Discover.trackBoxName).listenable(),
          builder: (context, Box<Track> tracks, _) {
            return Center();
          },
        ),
      ),
    );
  }
}
