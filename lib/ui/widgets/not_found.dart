import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class NotFound extends StatelessWidget {
  final String pathImg;
  final String title;
  final String subtitile;

  const NotFound({
    @required this.pathImg,
    @required this.title,
    @required this.subtitile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            pathImg,
            scale: 4,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            title,
            style: ThemeProvider.themeOf(context)
                .data
                .primaryTextTheme
                .headline6
                .copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 6,
            ),
            child: Text(
              subtitile,
              textAlign: TextAlign.center,
              style: ThemeProvider.themeOf(context)
                  .data
                  .primaryTextTheme
                  .bodyText1
                  .copyWith(
                    fontSize: 16,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
