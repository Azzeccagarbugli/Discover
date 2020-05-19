import 'package:Discover/ui/widgets/effects/neumorphism.dart';
import 'package:Discover/ui/widgets/graph.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';
import 'package:theme_provider/theme_provider.dart';

class FrontFlipCard extends StatelessWidget {
  const FrontFlipCard({
    Key key,
    @required GlobalKey chartKey,
    @required double maxNoiseDB,
    @required double minNoiseDB,
    @required double noiseDB,
    @required bool isRecording,
    @required AnimationController controller,
    @required Function onTap,
  })  : _chartKey = chartKey,
        _maxNoiseDB = maxNoiseDB,
        _minNoiseDB = minNoiseDB,
        _noiseDB = noiseDB,
        _isRecording = isRecording,
        _controller = controller,
        _onTap = onTap,
        super(key: key);

  final GlobalKey _chartKey;
  final double _maxNoiseDB;
  final double _minNoiseDB;
  final double _noiseDB;
  final bool _isRecording;
  final AnimationController _controller;
  final Function _onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            margin: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? Colors.white
                  : Colors.grey[900],
              shape: BoxShape.circle,
              boxShadow: Neumorphism.boxShadow(context),
            ),
            child: MainGraph(
              chartKey: _chartKey,
              maxNoiseDB: _maxNoiseDB,
              minNoiseDB: _minNoiseDB,
              noiseDB: _noiseDB,
              isActive: _isRecording,
            ),
          ),
        ),
        ScaleTransition(
          scale: _controller,
          child: Center(
            child: SpringButton(
              SpringButtonType.OnlyScale,
              Container(
                padding: const EdgeInsets.all(34),
                decoration: new BoxDecoration(
                  color: this._isRecording
                      ? Colors.red[600]
                      : ThemeProvider.themeOf(context)
                          .data
                          .scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                  boxShadow: Neumorphism.boxShadow(context),
                ),
                child: Icon(
                  this._isRecording ? Icons.mic_off : Icons.mic,
                  color: this._isRecording
                      ? Colors.white
                      : (ThemeProvider.themeOf(context).id == "light_theme"
                          ? Colors.blue[800]
                          : Colors.white),
                  size: 64,
                ),
              ),
              onTap: _onTap,
              useCache: false,
            ),
          ),
        ),
      ],
    );
  }
}
