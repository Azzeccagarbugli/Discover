import 'package:Discover/themes/theme.dart';
import 'package:Discover/ui/widgets/custom_slide_intro.dart';
import 'package:Discover/ui/widgets/effects/remove_glow_listview.dart';
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

  List<CustomSlideIntro> _listSlides(BuildContext context, int index) {
    return [
      CustomSlideIntro(
        pathImage: ThemeProvider.themeOf(context).id == "light_theme"
            ? "assets/images/welcome/welcome_light.png"
            : "assets/images/welcome/welcome_dark.png",
        title: "Welcome",
        subtitile:
            "Hello from Discover, start monitoring the decibel that surrounds you with style and elegance",
        controller: _controller,
        scaleLight: 3.5,
        scaleDark: 4.5,
        index: index,
      ),
      CustomSlideIntro(
        pathImage: ThemeProvider.themeOf(context).id == "light_theme"
            ? "assets/images/welcome/listen_light.png"
            : "assets/images/welcome/listen_dark.png",
        title: "Listen",
        subtitile:
            "Allow the application to use the microphone so that would be possible to record and catch sounds",
        controller: _controller,
        scaleLight: 3.0,
        scaleDark: 4.0,
        index: index,
      ),
      CustomSlideIntro(
        pathImage: ThemeProvider.themeOf(context).id == "light_theme"
            ? "assets/images/welcome/love_light.png"
            : "assets/images/welcome/love_dark.png",
        title: "Save",
        subtitile:
            "Save your favorite tracks in a separated page to check and fully enjoy them quickly",
        controller: _controller,
        scaleLight: 3.0,
        scaleDark: 3.2,
        index: index,
      ),
      CustomSlideIntro(
        pathImage: ThemeProvider.themeOf(context).id == "light_theme"
            ? "assets/images/welcome/share_light.png"
            : "assets/images/welcome/share_dark.png",
        title: "Share",
        subtitile:
            "Send to your friends, to your family or to whoever your best tracks so that they could see them",
        controller: _controller,
        scaleLight: 3.2,
        scaleDark: 3.2,
        index: index,
      ),
      CustomSlideIntro(
        pathImage: ThemeProvider.themeOf(context).id == "light_theme"
            ? "assets/images/welcome/done_light.png"
            : "assets/images/welcome/done_dark.png",
        title: "Let's go!",
        subtitile:
            "Start your new adventure right now, and don't forget to drink milk because calcium is so damn good",
        controller: _controller,
        scaleDark: 4.0,
        scaleLight: 4.4,
        index: index,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _customTheme.getStyleUI(
      ThemeProvider.optionsOf<SystemUI>(context).ui,
    );
    return ScrollConfiguration(
      behavior: RemoveGlow(),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return _listSlides(context, index)[index];
        },
        itemCount: 5,
        controller: _controller,
        duration: 1200,
        loop: false,
        pagination: SwiperPagination(
          margin: EdgeInsetsDirectional.only(
            bottom: MediaQuery.of(context).size.height / 6,
          ),
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
      ),
    );
  }
}
