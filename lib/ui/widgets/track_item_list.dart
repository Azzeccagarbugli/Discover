import 'package:Discover/models/track.dart';
import 'package:Discover/ui/views/track_page.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

import 'effects/neumorphism.dart';

class TrackItemList extends StatelessWidget {
  const TrackItemList({
    Key key,
    @required this.trk,
  }) : super(key: key);

  final Track trk;

  static int diffInDays(DateTime date1, DateTime date2) {
    return ((date1.difference(date2) -
                    Duration(hours: date1.hour) +
                    Duration(hours: date2.hour))
                .inHours /
            24)
        .round();
  }

  static Widget buildIcon(Track trk) {
    switch (diffInDays(DateTime.now(), trk.date)) {
      case 0:
        return Chip(
          backgroundColor: Colors.green[600],
          label: Text(
            'TODAY',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        );
      case 1:
        return Chip(
          backgroundColor: Colors.amber[800],
          label: Text(
            'A DAY AGO',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        );
      default:
        return Icon(
          Icons.graphic_eq,
          color: Colors.grey[400],
          size: 16,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: new BoxDecoration(
        color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
        boxShadow: Neumorphism.boxShadow(context),
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CurrentTrackView(
                track: trk,
              ),
            ),
          );
        },
        trailing: buildIcon(trk),
        title: Text(
          DateFormat('EEEE, MMM d').format(trk.date),
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: ThemeProvider.themeOf(context)
              .data
              .primaryTextTheme
              .headline6
              .copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          'Recorded at ' + DateFormat('hh:mm a').format(trk.date),
          style: ThemeProvider.themeOf(context).data.primaryTextTheme.bodyText1,
        ),
        leading: Container(
          height: 42,
          width: 42,
          padding: const EdgeInsets.all(6),
          decoration: new BoxDecoration(
            color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
            boxShadow: Neumorphism.boxShadow(context),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: FlareActor(
              "assets/flares/recording.flr",
              fit: BoxFit.scaleDown,
              color: ThemeProvider.themeOf(context).data.accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
