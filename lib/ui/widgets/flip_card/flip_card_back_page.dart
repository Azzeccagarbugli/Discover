import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';
import 'package:theme_provider/theme_provider.dart';

class BackFlipCard extends StatefulWidget {
  const BackFlipCard({
    Key key,
    @required double value,
    @required bool isRecording,
  })  : _value = value,
        _isRecording = isRecording,
        super(key: key);

  final double _value;
  final bool _isRecording;

  @override
  _BackFlipCardState createState() => _BackFlipCardState();
}

class _BackFlipCardState extends State<BackFlipCard> {
  List<Sound> _lst = new List<Sound>();

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    // _lst.add(Sound(widget._value));
    // print(_lst.toString());

    if (!widget._isRecording) {
      _isSaving = false;
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
            child: Center(
              child: ListTile(
                onTap: () {
                  print("object");
                },
                leading: SpringButton(
                  SpringButtonType.OnlyScale,
                  Container(
                    decoration: new BoxDecoration(
                      color: ThemeProvider.themeOf(context)
                          .data
                          .scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                      boxShadow: Neumorphism.boxShadow(context),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                      child: Icon(
                        Icons.graphic_eq,
                        color: this.widget._isRecording
                            ? (_isSaving ? Colors.green[400] : Colors.orange)
                            : Colors.grey[400],
                        size: 42,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _isSaving = !_isSaving;
                    });
                  },
                  useCache: false,
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
                  "Tap to save the current session of sounds",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                trailing: Icon(
                  Icons.brightness_1,
                  color: Colors.grey[400],
                  size: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
