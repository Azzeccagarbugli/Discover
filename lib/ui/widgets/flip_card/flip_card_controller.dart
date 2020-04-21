import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'flip_card_back_page.dart';
import 'flip_card_front_page.dart';

class FlipCardController extends StatelessWidget {
  const FlipCardController({
    Key key,
    @required GlobalKey<AnimatedCircularChartState> chartKey,
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

  final GlobalKey<AnimatedCircularChartState> _chartKey;
  final double _maxNoiseDB;
  final double _minNoiseDB;
  final double _noiseDB;
  final bool _isRecording;
  final AnimationController _controller;
  final Function _onTap;

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      flipOnTouch: true,
      back: BackFlipCard(
        value: _noiseDB,
        isRecording: _isRecording,
      ),
      front: FrontFlipCard(
        chartKey: _chartKey,
        maxNoiseDB: _maxNoiseDB,
        minNoiseDB: _minNoiseDB,
        noiseDB: _noiseDB,
        isRecording: _isRecording,
        controller: _controller,
        onTap: _onTap,
      ),
    );
  }
}
