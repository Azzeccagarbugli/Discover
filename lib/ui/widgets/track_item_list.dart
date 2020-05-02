import 'package:Discover/models/track.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

import 'effects/neumorphism.dart';

class TrackItemList extends StatelessWidget {
  const TrackItemList({
    Key key,
    @required this.trk,
  }) : super(key: key);

  final Track trk;

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
        trailing: Icon(
          Icons.graphic_eq,
          color: Colors.grey[400],
          size: 16,
        ),
        title: Text(
          DateFormat('EEEE, MMM d, ' 'yyyy').format(trk.date),
          style: ThemeProvider.themeOf(context)
              .data
              .primaryTextTheme
              .title
              .copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          'Recorded at ' + DateFormat('hh:mm a').format(trk.date),
          style: ThemeProvider.themeOf(context).data.primaryTextTheme.body1,
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
            child: FaIcon(
              FontAwesomeIcons.play,
              color: Colors.green,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
