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
      primaryColor: Colors.blue[50],
      textSelectionColor: Colors.blue[800],
      scaffoldBackgroundColor: Colors.white,
      accentColor: Colors.blue[500],
      primaryTextTheme: TextTheme(
        title: TextStyle(color: Colors.grey[800]),
        body1: TextStyle(color: Colors.grey[600]),
      ),
    ),
  );

  static AppTheme darkTheme = new AppTheme(
    id: "dark_theme",
    description: "Dark Color Scheme",
    options: SystemUI(
      ui: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.grey[900],
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    data: ThemeData(
      fontFamily: 'Quicksand',
      brightness: Brightness.light,
      textSelectionColor: Colors.amber[800],
      primaryColor: Colors.black45,
      scaffoldBackgroundColor: Colors.grey[900],
      accentColor: Colors.amber[400],
      primaryTextTheme: TextTheme(
        title: TextStyle(color: Colors.white),
        body1: TextStyle(color: Colors.grey[200]),
      ),
    ),
  );

  AppTheme getLight() {
    return lightTheme;
  }

  AppTheme getDark() {
    return darkTheme;
  }

  getStyleUI(SystemUiOverlayStyle ui) {
    return SystemChrome.setSystemUIOverlayStyle(ui);
  }
}

class SystemUI implements AppThemeOptions {
  final SystemUiOverlayStyle ui;
  SystemUI({
    @required this.ui,
  });
}
