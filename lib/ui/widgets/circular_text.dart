import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:theme_provider/theme_provider.dart';

class BuildCircularText extends StatelessWidget {
  final bool radiusChange;
  final bool isSaving;
  final CircularTextDirection dir;

  const BuildCircularText({
    Key key,
    this.dir,
    this.radiusChange,
    this.isSaving,
  }) : super(key: key);

  List<TextItem> _recordText(BuildContext context) {
    List<TextItem> _list = new List<TextItem>();
    for (var i = 0; i < 6; i++) {
      _list.add(
        TextItem(
          text: Text(
            i % 2 == 0 ? "RECORD".toUpperCase() : "•".toUpperCase(),
            style: ThemeProvider.themeOf(context)
                .data
                .primaryTextTheme
                .headline6
                .copyWith(
                  fontWeight: FontWeight.bold,
                  color: !isSaving
                      ? ThemeProvider.themeOf(context).id == "light_theme"
                          ? Colors.grey[400]
                          : Colors.grey[850]
                      : Colors.red[400],
                ),
          ),
          space: 16,
          startAngle: i * 60.0,
          startAngleAlignment: StartAngleAlignment.center,
          direction: dir,
        ),
      );
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return radiusChange
        ? Transform.rotate(
            angle: -pi / 3,
            child: CircularText(
              children: _recordText(context),
            ),
          )
        : CircularText(
            children: _recordText(context),
          );
  }
}
