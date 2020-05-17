import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/tile_settings.dart';
import 'package:flutter/material.dart';
import 'package:Discover/ui/widgets/title_page.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Future<bool> _checkMicPermission() async {
    return await Permission.contacts.shouldShowRequestRationale;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: TitlePage(),
        ),
        Expanded(
          flex: 2,
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
                      "Grant or deny the usage of the microphone, you should allow it",
                  onTap: () async {
                    if (await Permission.microphone.isDenied) {
                      openAppSettings();
                    }
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
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green[400],
                              )
                            : Icon(
                                Icons.cancel,
                                color: Colors.red[400],
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
                      ? "Enjoy the darkness right now and safe your battery"
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
                      "In this way you will fully erase your tracks, even the saved ones",
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
    );
  }
}
