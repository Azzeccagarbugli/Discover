import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/tile_settings.dart';
import 'package:flutter/material.dart';
import 'package:Discover/ui/widgets/title_page.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Container(
            child: TitlePage(
              content: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      ThemeProvider.themeOf(context).id == "light_theme"
                          ? "assets/images/settings_light.png"
                          : "assets/images/settings_dark.png",
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
                            color: ThemeProvider.themeOf(context)
                                .data
                                .textSelectionColor,
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
                                  "Feel comfortable",
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
            height: MediaQuery.of(context).size.height / 4,
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
              ),
              child: Column(
                children: <Widget>[
                  TileSettings(
                    background: ThemeProvider.themeOf(context)
                        .data
                        .scaffoldBackgroundColor,
                    isAlert: false,
                    iconLead: Icon(
                      Icons.mic,
                      color: ThemeProvider.themeOf(context).data.accentColor,
                    ),
                    title: "Microphone permission",
                    subtitle:
                        "Enable or disable the usage of the microphone to allow the app to works",
                    onTap: () async {
                      openAppSettings();
                    },
                    widgetTrail: FutureBuilder(
                      future: Permission.microphone.isGranted,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.hasError) {
                          return Icon(
                            Icons.help_outline,
                            color: Colors.orange,
                          );
                        } else {
                          return snapshot.data == true
                              ? Container(
                                  height: 10,
                                  width: 10,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green[400],
                                  ),
                                )
                              : Container(
                                  height: 10,
                                  width: 10,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red[400],
                                  ),
                                );
                        }
                      },
                    ),
                  ),
                  Divider(),
                  TileSettings(
                    background: ThemeProvider.themeOf(context)
                        .data
                        .scaffoldBackgroundColor,
                    isAlert: false,
                    iconLead: Icon(
                      ThemeProvider.themeOf(context).id == "light_theme"
                          ? Icons.brightness_2
                          : Icons.brightness_7,
                      color: ThemeProvider.themeOf(context).data.accentColor,
                    ),
                    title: ThemeProvider.themeOf(context).id == "light_theme"
                        ? "Dark mode"
                        : "Light mode",
                    subtitle: ThemeProvider.themeOf(context).id == "light_theme"
                        ? "Enjoy the dark theme right now and save your battery"
                        : "If you praise the sun this is exactly made for you",
                    onTap: () {
                      ThemeProvider.controllerOf(context).nextTheme();
                    },
                  ),
                  Divider(),
                  TileSettings(
                    isAlert: true,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red[700],
                        offset: Offset(4.0, 4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: Colors.red[800],
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                    background: Colors.red[600],
                    iconLead: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    title: "Delete all the tracks",
                    subtitle:
                        "In this way you will remove all the tracks registered in the app",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            backgroundColor: ThemeProvider.themeOf(context)
                                .data
                                .scaffoldBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                            title: Text(
                              "Erase all the data?",
                              style: ThemeProvider.themeOf(context)
                                  .data
                                  .primaryTextTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "All your data will no longer be recoverable, then don't get angry please",
                                  style: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryTextTheme
                                      .bodyText1,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Hive.box<Track>(Discover.trackBoxName)
                                        .clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "DELETE",
                                    style: ThemeProvider.themeOf(context)
                                        .data
                                        .primaryTextTheme
                                        .headline6
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
