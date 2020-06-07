import 'dart:math';

import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/bar_line.dart';
import 'package:Discover/ui/widgets/row_building_values.dart';
import 'package:Discover/ui/widgets/share_track.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spring_button/spring_button.dart';
import 'package:theme_provider/theme_provider.dart';

import 'effects/neumorphism.dart';

class SavedItem extends StatelessWidget {
  const SavedItem({
    Key key,
    @required this.trk,
  }) : super(key: key);

  final Track trk;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(36.0),
        ),
        boxShadow: Neumorphism.boxShadow(context),
      ),
      child: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(36),
                ),
                child: ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    color: ThemeProvider.themeOf(context)
                        .data
                        .scaffoldBackgroundColor,
                    height: MediaQuery.of(context).size.height / 1.6,
                    width: double.infinity,
                    child: BuildLineGraph(
                      trk: trk,
                      enableTouch: false,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 16,
                left: 16,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: ThemeProvider.themeOf(context)
                        .data
                        .scaffoldBackgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(36.0),
                    ),
                    boxShadow: Neumorphism.boxShadow(context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ValueBuilding(
                        value: trk.sound.reduce(max),
                        desc: "MAX",
                        color: Colors.red[300],
                      ),
                      ValueBuilding(
                        value: trk.sound.reduce((a, b) => a + b) /
                            trk.sound.length,
                        desc: "AVG",
                        color: ThemeProvider.themeOf(context).data.accentColor,
                      ),
                      ValueBuilding(
                        value: trk.sound.reduce(min),
                        desc: "MIN",
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 22,
            right: 22,
            left: 22,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SpringButton(
                  SpringButtonType.OnlyScale,
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: ThemeProvider.themeOf(context)
                          .data
                          .scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                      boxShadow: Neumorphism.boxShadow(context),
                    ),
                    child: Icon(
                      Icons.share,
                      color: ThemeProvider.themeOf(context)
                          .data
                          .primaryTextTheme
                          .headline6
                          .color,
                    ),
                  ),
                  onTap: () async {
                    await generateResume(this.trk);
                    OpenFile.open(await pathFile(this.trk));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 22,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat('EEEE, MMM d').format(trk.date),
                  style: ThemeProvider.themeOf(context)
                      .data
                      .primaryTextTheme
                      .bodyText1
                      .copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Recorded at ' + DateFormat('hh:mm a').format(trk.date),
                  style: ThemeProvider.themeOf(context)
                      .data
                      .primaryTextTheme
                      .bodyText1
                      .copyWith(
                        fontSize: 22,
                      ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
