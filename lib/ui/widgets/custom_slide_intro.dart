import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:theme_provider/theme_provider.dart';

import 'effects/neumorphism.dart';

class CustomSlideIntro extends StatelessWidget {
  final String pathImage;
  final String title;
  final String subtitile;
  final double scaleLight;
  final double scaleDark;

  final SwiperController controller;

  const CustomSlideIntro({
    Key key,
    this.pathImage,
    this.title,
    this.subtitile,
    this.controller,
    this.scaleLight,
    this.scaleDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    color: ThemeProvider.themeOf(context).data.primaryColor,
                    width: double.infinity,
                    height: 250,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    pathImage,
                    scale: ThemeProvider.themeOf(context).id == "light_theme"
                        ? scaleLight
                        : scaleDark,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 32,
                ),
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
                GestureDetector(
                  onTap: () {
                    controller.next();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 62,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 42,
                      vertical: 32,
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
