import 'dart:async';
import 'dart:math';

import 'package:Discover/ui/widgets/flip_card/flip_card_controller.dart';
import 'package:Discover/ui/widgets/waves.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:theme_provider/theme_provider.dart';

class HomepageView extends StatefulWidget {
  @override
  _HomepageViewState createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter;

  double _noiseDB = 0;
  double _maxNoiseDB = 0;
  double _minNoiseDB = 0;

  bool _updateValue = true;

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  AnimationController _controllerPopUpButton;
  AnimationController _controllerFadeWave;

  @override
  void initState() {
    super.initState();
    _controllerPopUpButton = AnimationController(
      duration: const Duration(
        milliseconds: 500,
      ),
      vsync: this,
    )..forward();
    _controllerFadeWave = AnimationController(
      duration: const Duration(
        milliseconds: 400,
      ),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controllerFadeWave.dispose();
    _controllerPopUpButton.dispose();
    if (_noiseSubscription != null) {
      _noiseSubscription.cancel();
    }
    super.dispose();
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
      _noiseDB = noiseReading.db;
    });
  }

  void startRecorder() async {
    try {
      _noiseMeter = new NoiseMeter();
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } on NoiseMeterException catch (exception) {
      print(exception);
    }
  }

  void stopRecorder() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  void _cycleSamples() {
    setState(() {
      if (_updateValue) {
        _minNoiseDB = _noiseDB;
        _updateValue = false;
      }

      if (_noiseDB > _maxNoiseDB) {
        _maxNoiseDB = _noiseDB;
      }
      if (_minNoiseDB > _noiseDB) {
        _minNoiseDB = _noiseDB;
      }
    });
  }

  Widget _onBottom(Widget child) {
    return Positioned(
      left: 0,
      right: 0,
      top: MediaQuery.of(context).size.height / 2,
      child: Align(
        alignment: Alignment.center,
        child: FadeTransition(
          opacity: _controllerFadeWave,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isRecording) {
      _cycleSamples();
      _controllerFadeWave.forward();
    } else {
      _controllerFadeWave.reverse();
    }
    return Scaffold(
      backgroundColor:
          ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
      body: Container(
        child: Stack(
          children: <Widget>[
            _onBottom(AnimatedWave(
              height: 220,
              speed: 0.2,
              offset: 1,
            )),
            _onBottom(AnimatedWave(
              height: 240,
              speed: 0.9,
              offset: pi,
            )),
            _onBottom(AnimatedWave(
              height: 180,
              speed: 0.4,
              offset: pi / 2,
            )),
            Center(
              child: FlipCardController(
                chartKey: _chartKey,
                maxNoiseDB: _maxNoiseDB,
                minNoiseDB: _minNoiseDB,
                noiseDB: _noiseDB,
                isRecording: _isRecording,
                controller: _controllerPopUpButton,
                onTap: () {
                  if (!this._isRecording) {
                    return this.startRecorder();
                  }
                  this.stopRecorder();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
