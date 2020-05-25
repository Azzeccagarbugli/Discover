import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomSlideIntro extends StatelessWidget {
  final String pathImage;
  final String title;
  final String subtitile;

  const CustomSlideIntro({
    Key key,
    this.pathImage,
    this.title,
    this.subtitile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
      child: SafeArea(
        minimum: const EdgeInsets.all(
          24,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image.asset(
                pathImage,
                scale: 3.5,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: ThemeProvider.themeOf(context)
                        .data
                        .primaryTextTheme
                        .headline6
                        .copyWith(
                          fontSize: 38,
                        ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    subtitile,
                    textAlign: TextAlign.center,
                    style: ThemeProvider.themeOf(context)
                        .data
                        .primaryTextTheme
                        .bodyText1
                        .copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
