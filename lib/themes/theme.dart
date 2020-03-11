import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomTheme {
  static AppTheme lightTheme = new AppTheme(
    id: "light_theme",
    description: "Light Color Scheme",
    options: SystemUI(
      ui: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    data: ThemeData(
      fontFamily: 'Quicksand',
      brightness: Brightness.dark,
      primaryColor: Colors.blue[800],
      textSelectionColor: Colors.green[800],
      scaffoldBackgroundColor: Colors.white,
    ),
  );

  static AppTheme darkTheme = new AppTheme(
    id: "dark_theme",
    description: "Dark Color Scheme",
    options: SystemUI(
      ui: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    data: ThemeData(
      fontFamily: 'Quicksand',
      brightness: Brightness.light,
      textSelectionColor: Colors.white,
      primaryColor: Colors.amber,
      scaffoldBackgroundColor: Colors.grey[900],
    ),
  );

  AppTheme getLight() {
    return lightTheme;
  }

  AppTheme getDark() {
    return darkTheme;
  }
}

class SystemUI implements AppThemeOptions {
  final SystemUiOverlayStyle ui;
  SystemUI({
    @required this.ui,
  });
}
