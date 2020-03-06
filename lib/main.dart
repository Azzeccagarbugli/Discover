import 'dart:async';
import 'dart:math';

import 'package:Discover/themes/theme.dart';
import 'package:Discover/ui/widgets/flip_card/flip_card_controller.dart';
import 'package:Discover/ui/widgets/navigation_bar.dart';
import 'package:Discover/ui/widgets/waves.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'package:noise_meter/noise_meter.dart';
import 'package:theme_provider/theme_provider.dart';

void main() => runApp(Discover());

class Discover extends StatelessWidget {
  final CustomTheme _customTheme = new CustomTheme();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return ThemeProvider(
      themes: [
        _customTheme.getLight(),
        _customTheme.getDark(),
      ],
      child: MaterialApp(
        home: ThemeConsumer(
          child: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter;

  double _noiseDB = 0;
  double _maxNoiseDB = 0;
  double _minNoiseDB = 0;

  int _selectedIndex = 0;

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

  Widget onBottom(Widget child) {
    return Positioned.fill(
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
      body: Stack(
        children: <Widget>[
          onBottom(AnimatedWave(
            height: 220,
            speed: 1.0,
          )),
          onBottom(AnimatedWave(
            height: 240,
            speed: 0.9,
            offset: pi,
          )),
          onBottom(AnimatedWave(
            height: 180,
            speed: 1.2,
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
          Positioned(
            bottom: 36,
            left: 24,
            right: 24,
            child: CustomBottomNavigationBar(
              selectedIndex: _selectedIndex,
              changeIndex: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
