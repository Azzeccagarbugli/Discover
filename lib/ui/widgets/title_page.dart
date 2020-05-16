import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:theme_provider/theme_provider.dart';

import 'effects/neumorphism.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 48,
        left: 12,
        right: 12,
      ),
      decoration: new BoxDecoration(
        color: ThemeProvider.themeOf(context).data.primaryColor,
        boxShadow: Neumorphism.boxShadow(context),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            25.0,
          ),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              ThemeProvider.themeOf(context).id == "light_theme"
                  ? "assets/images/settings_light.png"
                  : "assets/images/settings_dark.png",
              scale: 6,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(25),
                right: Radius.circular(25),
              ),
              child: ClipPath(
                clipper: WaveClipperTwo(reverse: true),
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color:
                        ThemeProvider.themeOf(context).data.textSelectionColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Be comfortable",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
