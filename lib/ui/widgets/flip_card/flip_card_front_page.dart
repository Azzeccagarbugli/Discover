import 'package:Discover/ui/widgets/graph.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

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
                padding: const EdgeInsets.all(24),
                decoration: new BoxDecoration(
                  color: this._isRecording ? Colors.red[600] : Colors.white,
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
                child: Icon(
                  this._isRecording ? Icons.mic_off : Icons.mic,
                  color: this._isRecording ? Colors.white : Colors.blue[800],
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
