import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomTheme {
  static AppTheme lightTheme = new AppTheme(
    id: "light_theme",
    description: "Light Color Scheme",
    data: ThemeData(
      fontFamily: 'Quicksand',
      primaryColor: Colors.blue[800],
      scaffoldBackgroundColor: Colors.white,
    ),
  );

  static AppTheme darkTheme = new AppTheme(
    id: "dark_theme",
    description: "Dark Color Scheme",
    data: ThemeData(
      fontFamily: 'Quicksand',
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
