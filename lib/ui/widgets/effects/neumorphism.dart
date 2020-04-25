import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class Neumorphism {
  static boxShadow(BuildContext context) {
    return [
      BoxShadow(
        color: ThemeProvider.themeOf(context).id == "light_theme"
            ? Colors.grey[500]
            : Colors.black87,
        offset: Offset(4.0, 4.0),
        blurRadius: 15.0,
        spreadRadius: 1.0,
      ),
      BoxShadow(
        color: ThemeProvider.themeOf(context).id == "light_theme"
            ? Colors.white
            : Colors.grey[900],
        offset: Offset(-4.0, -4.0),
        blurRadius: 15.0,
        spreadRadius: 1.0,
      ),
    ];
  }
}
