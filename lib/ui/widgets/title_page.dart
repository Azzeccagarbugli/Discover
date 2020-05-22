import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import 'effects/neumorphism.dart';

class TitlePage extends StatelessWidget {
  final Widget content;
  final bool useDecoration;

  const TitlePage({
    Key key,
    this.content,
    this.useDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: useDecoration
          ? const EdgeInsets.only(
              left: 12,
              right: 12,
            )
          : null,
      decoration: useDecoration
          ? new BoxDecoration(
              color: ThemeProvider.themeOf(context).data.primaryColor,
              boxShadow: Neumorphism.boxShadow(context),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  25.0,
                ),
              ),
            )
          : null,
      child: content,
    );
  }
}
