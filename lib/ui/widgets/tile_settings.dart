import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import 'effects/neumorphism.dart';

class TileSettings extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onTap;
  final Icon iconLead;
  final Widget widgetTrail;
  final Color background;
  final List<BoxShadow> boxShadow;
  final bool isAlert;

  const TileSettings({
    Key key,
    this.title,
    this.subtitle,
    this.onTap,
    this.iconLead,
    this.widgetTrail,
    this.background,
    this.boxShadow,
    this.isAlert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Container(
        decoration: new BoxDecoration(
          color: background,
          borderRadius: BorderRadius.all(
            Radius.circular(
              12.0,
            ),
          ),
          boxShadow: Neumorphism.boxShadow(context),
        ),
        child: Theme(
          data: ThemeData(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: ListTile(
            isThreeLine: true,
            onTap: onTap,
            title: Row(
              children: <Widget>[
                Text(
                  title,
                  style: isAlert
                      ? ThemeProvider.themeOf(context)
                          .data
                          .primaryTextTheme
                          .headline6
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                      : ThemeProvider.themeOf(context)
                          .data
                          .primaryTextTheme
                          .headline6
                          .copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
                Spacer(),
                widgetTrail != null ? widgetTrail : SizedBox(),
              ],
            ),
            subtitle: Text(
              subtitle,
              style: isAlert
                  ? ThemeProvider.themeOf(context)
                      .data
                      .primaryTextTheme
                      .bodyText1
                      .copyWith(
                        color: Colors.white,
                      )
                  : ThemeProvider.themeOf(context)
                      .data
                      .primaryTextTheme
                      .bodyText1,
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
              ),
              child: Container(
                decoration: new BoxDecoration(
                  color: background,
                  boxShadow:
                      isAlert ? boxShadow : Neumorphism.boxShadow(context),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: iconLead,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
