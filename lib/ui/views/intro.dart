import 'package:Discover/themes/theme.dart';
import 'package:Discover/ui/widgets/custom_slide_intro.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:theme_provider/theme_provider.dart';

class IntroView extends StatefulWidget {
  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final CustomTheme _customTheme = new CustomTheme();

  // body: IntroSlider(
  //   slides: _slides,
  //   isShowDotIndicator: false,
  // ),
  @override
  Widget build(BuildContext context) {
    _customTheme.getStyleUI(
      ThemeProvider.optionsOf<SystemUI>(context).ui,
    );
    return Scaffold(
      body: LiquidSwipe(
        pages: <Container>[
          CustomSlideIntro(
            pathImage: ThemeProvider.themeOf(context).id == "light_theme"
                ? "assets/images/welcome/welcome_light.png"
                : "assets/images/welcome/welcome_dark.png",
            title: "Welcome",
            subtitile:
                "Hello from Discover, start monitoring now the amount of decibel that surrounds you to get more information from the environment around you",
          ),
          CustomSlideIntro(
            pathImage: ThemeProvider.themeOf(context).id == "light_theme"
                ? "assets/images/welcome/listen_light.png"
                : "assets/images/welcome/listen_dark.png",
            title: "Listen",
            subtitile:
                "Listen whatever rounds you to get more information from the environment around you",
          ),
        ],
      ),
    );
  }
}
