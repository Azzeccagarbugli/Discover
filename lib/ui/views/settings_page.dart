import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
              top: 48,
              left: 25,
              right: 25,
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
                    scale: 5.5,
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
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              ThemeProvider.themeOf(context)
                                  .data
                                  .textSelectionColor,
                              ThemeProvider.themeOf(context).data.accentColor,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Discover",
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Feel the sound",
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
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
