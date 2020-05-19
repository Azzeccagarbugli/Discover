import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/effects/glowicon.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  bool _isSaving = false;

  List<double> _values;

  Box<Track> _trackBox;

  @override
  void initState() {
    super.initState();
    _values = new List<double>();
    _trackBox = Hive.box<Track>(Discover.trackBoxName);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget._isRecording) {
      _isSaving = false;
    }

    if (_isSaving && widget._isRecording) {
      _values.add(widget._value);
    }

    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            height: 350,
            width: 350,
            margin: const EdgeInsets.all(26),
            decoration: new BoxDecoration(
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? Colors.white
                  : Colors.grey[900],
              shape: BoxShape.circle,
              boxShadow: Neumorphism.boxShadow(context),
            ),
            child: Center(
              child: ListTile(
                isThreeLine: true,
                leading: SpringButton(
                  SpringButtonType.OnlyScale,
                  Container(
                    decoration: new BoxDecoration(
                      color: ThemeProvider.themeOf(context)
                          .data
                          .scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                      boxShadow: this.widget._isRecording
                          ? Neumorphism.boxShadow(context)
                          : [
                              BoxShadow(
                                color: Colors.transparent,
                              )
                            ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Container(
                        height: 42,
                        width: 42,
                        child: !this.widget._isRecording
                            ? FlareActor(
                                "assets/flares/recording.flr",
                                fit: BoxFit.scaleDown,
                                color: Colors.grey[400],
                              )
                            : FlareActor(
                                "assets/flares/recording.flr",
                                fit: BoxFit.scaleDown,
                                color: _isSaving
                                    ? Colors.red[600]
                                    : Colors.green[400],
                                animation: "record",
                              ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _isSaving = !_isSaving;

                      Track _trk = new Track(
                        date: DateTime.now(),
                        sound: _values,
                        isSaved: false,
                      );

                      if (_values.isNotEmpty) _trackBox.add(_trk);
                    });
                  },
                  useCache: false,
                ),
                title: Text(
                  "RECORD",
                  style: ThemeProvider.themeOf(context)
                      .data
                      .primaryTextTheme
                      .headline6
                      .copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
                  child: Text(
                    widget._isRecording
                        ? (!_isSaving
                            ? "Tap to save and store the current session of sounds"
                            : "Tap to stop saving the current session of sounds")
                        : "Start to feel the sound around you, tap the mic on the other side",
                    style: ThemeProvider.themeOf(context)
                        .data
                        .primaryTextTheme
                        .bodyText1,
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                  ),
                ),
                trailing: this.widget._isRecording
                    ? (this._isSaving
                        ? GlowIconRecording(color: Colors.red[600])
                        : GlowIconRecording(color: Colors.green[400]))
                    : Icon(
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
