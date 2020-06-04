import 'package:Discover/models/track.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

import 'bar_line.dart';

class BuildTileHeaderTracks extends StatelessWidget {
  final Track trk;
  final String msg;

  const BuildTileHeaderTracks({
    Key key,
    this.trk,
    this.msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: BuildLineGraph(
            trk: trk,
            enableTouch: false,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
            child: ClipPath(
              clipper: WaveClipperTwo(reverse: true),
              child: Container(
                height: 76,
                decoration: BoxDecoration(
                  color: ThemeProvider.themeOf(context).data.textSelectionColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        msg,
                        style: ThemeProvider.themeOf(context)
                            .data
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        DateFormat('EEEE, MMM d').format(trk.date),
                        style: ThemeProvider.themeOf(context)
                            .data
                            .primaryTextTheme
                            .bodyText1
                            .copyWith(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color:
                  ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_right,
              size: 32,
              color: ThemeProvider.themeOf(context).data.accentColor,
            ),
          ),
        ),
        trk.isSaved
            ? Positioned(
                top: 0,
                left: 80,
                right: 80,
                child: ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: 26,
                    color:
                        ThemeProvider.themeOf(context).data.textSelectionColor,
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
