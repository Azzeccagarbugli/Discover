import 'package:flutter/material.dart';

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
            margin: const EdgeInsets.all(42),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500],
                  offset: Offset(4.0, 4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Container(
              height: 350,
              width: 350,
              child: Icon(
                Icons.lightbulb_outline,
                size: 82,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
