import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class BackFlipCard extends StatelessWidget {
  const BackFlipCard({
    Key key,
    @required double value,
  })  : _value = value,
        super(key: key);

  final double _value;

  @override
  Widget build(BuildContext context) {
    List<double> _buildSparkline(double value) {
      List<double> lst = new List<double>();
      lst.add(value);
      print(lst.length.toString());
      return lst;
    }

    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            height: 350,
            width: 350,
            margin: const EdgeInsets.all(42),
            decoration: new BoxDecoration(
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? Colors.white
                  : Colors.grey[900],
              shape: BoxShape.circle,
              boxShadow: Neumorphism.boxShadow(context),
            ),
            child: TapeDisk(),
          ),
        ),
      ],
    );
  }
}

class TapeDisk extends StatelessWidget {
  const TapeDisk({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(42),
            decoration: new BoxDecoration(
              boxShadow: Neumorphism.boxShadow(context),
              gradient: RadialGradient(
                radius: 2,
                stops: [
                  0.1,
                  0.4,
                  0.6,
                  0.9,
                ],
                colors: [
                  Colors.grey[900],
                  Colors.grey[700],
                  Colors.grey[800],
                  Colors.grey[600]
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 120,
                maxWidth: 120,
              ),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: new BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[900],
                      blurRadius: 7.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.lens,
                  color: Colors.red[600],
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
