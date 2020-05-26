import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import 'effects/neumorphism.dart';

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
    return Column(
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
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
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Text(
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
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 62,
                margin: const EdgeInsets.symmetric(
                  horizontal: 42,
                  vertical: 26,
                ),
                decoration: BoxDecoration(
                  color: ThemeProvider.themeOf(context)
                      .data
                      .scaffoldBackgroundColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(36.0),
                  ),
                  boxShadow: Neumorphism.boxShadow(context),
                ),
                child: Center(
                  child: Text(
                    "NEXT",
                    style: ThemeProvider.themeOf(context)
                        .data
                        .primaryTextTheme
                        .headline6
                        .copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
