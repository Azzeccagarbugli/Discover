import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/effects/glowicon.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:flare_flutter/flare_actor.dart';
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
  bool _isSaving = false;

  Track _trk;

  List<double> _values = new List<double>();

  Set<Track> _setTracks = new Set<Track>();

  void creationNewTrack(List<double> list, double val) {
    list.add(val);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget._isRecording) {
      _isSaving = false;
    }

    if (_isSaving) {
      creationNewTrack(_values, widget._value);
    }

    print(_setTracks.length);

    print(_setTracks);

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
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                      // child: Icon(
                      //   Icons.blur_on,
                      // color: this.widget._isRecording
                      //     ? (_isSaving ? Colors.red[600] : Colors.green[400])
                      //     : Colors.grey[400],
                      //   size: 42,
                      // ),
                      child: Container(
                        height: 42,
                        width: 42,
                        child: FlareActor(
                          "assets/flares/recording.flr",
                          fit: BoxFit.scaleDown,
                          color: this.widget._isRecording
                              ? (_isSaving
                                  ? Colors.red[600]
                                  : Colors.green[400])
                              : Colors.grey[400],
                          animation: "record",
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _isSaving = !_isSaving;

                      if (_isSaving) {
                        _trk = new Track(sound: _values, date: "HEY");
                        _setTracks.add(_trk);
                      }
                    });
                  },
                  useCache: false,
                ),
                title: Text(
                  "RECORD",
                  style: ThemeProvider.themeOf(context)
                      .data
                      .primaryTextTheme
                      .title
                      .copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
                subtitle: Text(
                  !_isSaving
                      ? "Tap to save the current session of sounds"
                      : "Tap to stop saving the current sounds",
                  style: ThemeProvider.themeOf(context)
                      .data
                      .primaryTextTheme
                      .body1,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
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
