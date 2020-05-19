import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class ValueBuilding extends StatelessWidget {
  final double value;
  final String desc;
  final Color color;

  const ValueBuilding({
    @required this.value,
    @required this.desc,
    @required this.color,
  });

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          value.toStringAsFixed(0),
          style: ThemeProvider.themeOf(context)
              .data
              .primaryTextTheme
              .bodyText1
              .copyWith(
                color: ThemeProvider.themeOf(context).id == "dark_theme"
                    ? Colors.grey[300]
                    : darken(color),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          desc,
          style: ThemeProvider.themeOf(context)
              .data
              .primaryTextTheme
              .bodyText1
              .copyWith(
                color: ThemeProvider.themeOf(context).id == "dark_theme"
                    ? Colors.grey[400]
                    : color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
