import 'package:Discover/themes/theme.dart';
import 'package:Discover/ui/widgets/custom_slide_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:theme_provider/theme_provider.dart';

class IntroView extends StatefulWidget {
  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final CustomTheme _customTheme = new CustomTheme();
  final SwiperController _controller = new SwiperController();

  List<CustomSlideIntro> _listSlides(BuildContext context) {
    return [
      CustomSlideIntro(
        pathImage: ThemeProvider.themeOf(context).id == "light_theme"
            ? "assets/images/welcome/welcome_light.png"
            : "assets/images/welcome/welcome_dark.png",
        title: "Welcome",
        subtitile:
            "Hello from Discover, start monitoring now the amount of decibel that surrounds you to get more information from the environment around you",
        controller: _controller,
        scaleLight: 3.5,
        scaleDark: 4.5,
      ),
      CustomSlideIntro(
        pathImage: ThemeProvider.themeOf(context).id == "light_theme"
            ? "assets/images/welcome/listen_light.png"
            : "assets/images/welcome/listen_dark.png",
        title: "Listen",
        subtitile:
            "Listen whatever rounds you to get more information from the environment around you",
        controller: _controller,
        scaleLight: 3.0,
        scaleDark: 4.0,
      ),
      CustomSlideIntro(
        pathImage: ThemeProvider.themeOf(context).id == "light_theme"
            ? "assets/images/welcome/love_light.png"
            : "assets/images/welcome/love_dark.png",
        title: "Save",
        subtitile:
            "Listen whatever rounds you to get more information from the environment around you",
        controller: _controller,
        scaleLight: 3.0,
        scaleDark: 3.2,
      ),
      CustomSlideIntro(
        pathImage: ThemeProvider.themeOf(context).id == "light_theme"
            ? "assets/images/welcome/share_light.png"
            : "assets/images/welcome/share_dark.png",
        title: "Share",
        subtitile:
            "Listen whatever rounds you to get more information from the environment around you",
        controller: _controller,
        scaleLight: 3.2,
        scaleDark: 3.2,
      ),
      CustomSlideIntro(
        pathImage: ThemeProvider.themeOf(context).id == "light_theme"
            ? "assets/images/welcome/done_light.png"
            : "assets/images/welcome/done_dark.png",
        title: "Go",
        subtitile:
            "Listen whatever rounds you to get more information from the environment around you",
        controller: _controller,
        scaleDark: 4.0,
        scaleLight: 4.4,
      ),
    ];
  }

  // body: IntroSlider(
  //   slides: _slides,
  //   isShowDotIndicator: false,
  // ),
  @override
  Widget build(BuildContext context) {
    _customTheme.getStyleUI(
      ThemeProvider.optionsOf<SystemUI>(context).ui,
    );
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return _listSlides(context)[index];
      },
      itemCount: _listSlides(context).length,
      controller: _controller,
      duration: 600,
      pagination: SwiperPagination(
        alignment: Alignment.center,
        builder: DotSwiperPaginationBuilder(
          size: 5,
          space: 8,
          activeColor: ThemeProvider.themeOf(context).id == "light_theme"
              ? Colors.grey[600]
              : Colors.white,
          color: ThemeProvider.themeOf(context).id == "light_theme"
              ? Colors.grey[300]
              : Colors.grey[850],
        ),
      ),
    );
  }
}
