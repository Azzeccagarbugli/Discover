import 'package:Discover/main.dart';
import 'package:Discover/models/track.dart';
import 'package:Discover/ui/widgets/circular_text.dart';
import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
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

class _BackFlipCardState extends State<BackFlipCard>
    with TickerProviderStateMixin {
  bool _isSaving = false;

  List<double> _values;

  Box<Track> _trackBox;

  AnimationController _rotationControllerFaster;
  AnimationController _rotationControllerSlower;

  @override
  void initState() {
    super.initState();
    _values = new List<double>();
    _trackBox = Hive.box<Track>(Discover.trackBoxName);
    _rotationControllerFaster = AnimationController(
      duration: const Duration(
        seconds: 18,
      ),
      vsync: this,
    );
    _rotationControllerSlower = AnimationController(
      duration: const Duration(
        seconds: 15,
      ),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationControllerFaster.dispose();
    _rotationControllerSlower.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget._isRecording) {
      _isSaving = false;
      _rotationControllerFaster.stop();
      _rotationControllerSlower.stop();
    } else {
      _rotationControllerFaster.repeat();
      _rotationControllerSlower.repeat();
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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0)
                    .animate(_rotationControllerFaster),
                child: BuildCircularText(
                  radiusChange: false,
                  dir: CircularTextDirection.clockwise,
                  isSaving: _isSaving,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: RotationTransition(
            turns:
                Tween(begin: 1.0, end: 0.0).animate(_rotationControllerSlower),
            child: BuildCircularText(
              dir: CircularTextDirection.anticlockwise,
              radiusChange: true,
              isSaving: _isSaving,
            ),
          ),
        ),
        Center(
          child: SpringButton(
            SpringButtonType.OnlyScale,
            Container(
              decoration: new BoxDecoration(
                color:
                    ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
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
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  height: 96,
                  width: 96,
                  child: !this.widget._isRecording
                      ? FlareActor(
                          "assets/flares/recording.flr",
                          fit: BoxFit.scaleDown,
                          color:
                              ThemeProvider.themeOf(context).id == "light_theme"
                                  ? Colors.grey[400]
                                  : Colors.grey[800],
                        )
                      : FlareActor(
                          "assets/flares/recording.flr",
                          fit: BoxFit.scaleDown,
                          color: !_isSaving
                              ? ThemeProvider.themeOf(context).id ==
                                      "light_theme"
                                  ? Colors.grey[400]
                                  : Colors.grey[800]
                              : Colors.red[600],
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
        ),
      ],
    );
  }
}
