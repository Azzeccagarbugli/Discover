import 'package:Discover/ui/widgets/tile_settings.dart';
import 'package:flutter/material.dart';
import 'package:Discover/ui/widgets/title_page.dart';

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
                TileSettings(),
                Divider(),
                TileSettings(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
