import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class BackFlipCard extends StatefulWidget {
  const BackFlipCard({
    Key key,
    @required double value,
  })  : _value = value,
        super(key: key);

  final double _value;

  @override
  _BackFlipCardState createState() => _BackFlipCardState();
}

class _BackFlipCardState extends State<BackFlipCard> {
  List<Sound> _lst = new List<Sound>();

  @override
  Widget build(BuildContext context) {
    _lst.add(Sound(widget._value));
    print(_lst.toString());
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
            child: Center(
              child: ListTile(
                leading: Icon(
                  Icons.radio_button_checked,
                  color: Colors.red,
                  size: 56,
                ),
                title: Text(
                  "RECORD",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                subtitle: Text(
                  "Save the current session of sounds",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
