import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:theme_provider/theme_provider.dart';

import 'effects/neumorphism.dart';

class TitlePage extends StatelessWidget {
  final Widget content;

  const TitlePage({
    Key key,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      decoration: new BoxDecoration(
        color: ThemeProvider.themeOf(context).data.primaryColor,
        boxShadow: Neumorphism.boxShadow(context),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            25.0,
          ),
        ),
      ),
      child: content,
    );
  }
}
