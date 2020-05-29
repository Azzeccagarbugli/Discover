import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spring_button/spring_button.dart';
import 'package:theme_provider/theme_provider.dart';

import 'effects/neumorphism.dart';

class CustomSlideIntro extends StatelessWidget {
  final String pathImage;
  final String title;
  final String subtitile;
  final double scaleLight;
  final double scaleDark;
  final int index;

  final SwiperController controller;

  const CustomSlideIntro({
    Key key,
    this.pathImage,
    this.title,
    this.subtitile,
    this.controller,
    this.scaleLight,
    this.scaleDark,
    this.index,
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
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: ThemeProvider.themeOf(context)
                      .data
                      .primaryTextTheme
                      .headline6
                      .copyWith(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                  ),
                  child: Text(
                    subtitile,
                    textAlign: TextAlign.center,
                    style: ThemeProvider.themeOf(context)
                        .data
                        .primaryTextTheme
                        .bodyText1
                        .copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                Spacer(),
                BottomButtonIntro(
                  controller: controller,
                  index: index,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomButtonIntro extends StatefulWidget {
  const BottomButtonIntro({
    Key key,
    @required this.controller,
    @required this.index,
  }) : super(key: key);

  final SwiperController controller;
  final int index;

  @override
  _BottomButtonIntroState createState() => _BottomButtonIntroState();
}

class _BottomButtonIntroState extends State<BottomButtonIntro> {
  Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = Permission.microphone.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            return SpringButton(
              SpringButtonType.OnlyScale,
              Container(
                width: MediaQuery.of(context).size.width,
                height: 62,
                margin: const EdgeInsets.symmetric(
                  horizontal: 42,
                  vertical: 32,
                ),
                decoration: buildBoxDecoration(
                  context,
                  snapshot.data,
                ),
                child: buildWidgetChild(
                  context,
                  snapshot.data,
                ),
              ),
              onTap: () {
                controllerLogic(widget.index, snapshot.data);
              },
              useCache: false,
            );
        }
      },
    );
  }

  void controllerLogic(int index, bool permission) async {
    if (index == 0 || permission) {
      widget.controller.next();
    } else {
      await Permission.microphone.request();
      setState(() {
        _future = Permission.microphone.isGranted;
      });
    }
  }

  Widget buildWidgetChild(BuildContext context, bool permission) {
    if (permission || widget.index == 0) {
      return Center(
        child: Text(
          widget.index == 4 ? "FINISH" : "NEXT",
          style: ThemeProvider.themeOf(context)
              .data
              .primaryTextTheme
              .headline6
              .copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
      );
    } else {
      return Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.mic_none,
                color: Colors.red[800],
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              "ALLOW THE MICROPHONE",
              style: ThemeProvider.themeOf(context)
                  .data
                  .primaryTextTheme
                  .headline6
                  .copyWith(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      );
    }
  }

  BoxDecoration buildBoxDecoration(BuildContext context, bool permission) {
    if (permission || widget.index == 0) {
      return BoxDecoration(
        color: ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(36.0),
        ),
        boxShadow: Neumorphism.boxShadow(context),
      );
    } else {
      return BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.red[700],
            offset: Offset(4.0, 4.0),
            blurRadius: 8.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colors.red[800],
            offset: Offset(-4.0, -4.0),
            blurRadius: 8.0,
            spreadRadius: 1.0,
          ),
        ],
        color: Colors.red[600],
        borderRadius: BorderRadius.all(
          Radius.circular(36.0),
        ),
      );
    }
  }
}
