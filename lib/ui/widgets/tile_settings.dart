import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import 'effects/neumorphism.dart';

class TileSettings extends StatelessWidget {
  const TileSettings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Container(
        decoration: new BoxDecoration(
          color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
          boxShadow: Neumorphism.boxShadow(context),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              12.0,
            ),
          ),
        ),
        child: ListTile(
          onTap: () {
            ThemeProvider.controllerOf(context).nextTheme();
          },
          title: Text(
            "Dark mode",
            style: ThemeProvider.themeOf(context)
                .data
                .primaryTextTheme
                .headline6
                .copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            "Dark mode",
            style:
                ThemeProvider.themeOf(context).data.primaryTextTheme.bodyText1,
          ),
          leading: Container(
            decoration: new BoxDecoration(
              color:
                  ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
              boxShadow: Neumorphism.boxShadow(context),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.brightness_2,
              color: ThemeProvider.themeOf(context).data.accentColor,
              size: 32,
            ),
          ),
          trailing: Icon(
            Icons.cached,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
