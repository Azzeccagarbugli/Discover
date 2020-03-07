import 'package:Discover/themes/theme.dart';
import 'package:Discover/ui/views/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:theme_provider/theme_provider.dart';

void main() => runApp(Discover());

class Discover extends StatelessWidget {
  final CustomTheme _customTheme = new CustomTheme();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return ThemeProvider(
      themes: [
        _customTheme.getLight(),
        _customTheme.getDark(),
      ],
      child: MaterialApp(
        home: ThemeConsumer(
          child: NavigationView(),
        ),
      ),
    );
  }
}
