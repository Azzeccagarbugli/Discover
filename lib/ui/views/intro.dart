import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:theme_provider/theme_provider.dart';

class IntroView extends StatefulWidget {
  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  List<Slide> _slides = new List();

  @override
  void initState() {
    super.initState();
    _slides.add(
      new Slide(
        description:
            "Allow miles wound place the leave had. To sitting subject no improve studied limited",
        pathImage: "assets/images/welcome/welcome_dark.png",
      ),
    );
    _slides.add(
      new Slide(
        title: "PENCIL",
        description:
            "Ye indulgence unreserved connection alteration appearance",
        // pathImage: "images/photo_pencil.png",
      ),
    );
    _slides.add(
      new Slide(
        title: "RULER",
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        // pathImage: "images/photo_ruler.png",
      ),
    );
  }
  //  CustomSlideIntro(
  // pathImage: ThemeProvider.themeOf(context).id == "light_theme"
  //     ? "assets/images/welcome/welcome_light.png"
  //     : "assets/images/welcome/welcome_dark.png",
  //       title: "Welcome",
  //       subtitile:
  //           "Hello from Discover, start monitoring now the amount of decibel that surrounds you to get more information from the environment around you",
  //     ),

  // body: IntroSlider(
  //   slides: _slides,
  //   isShowDotIndicator: false,
  // ),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroSlider(
        slides: _slides,
      ),
    );
  }
}
