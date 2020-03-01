import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noise_meter/noise_meter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter;

  double _noiseDB = 0;

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  @override
  void initState() {
    super.initState();
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
    List<CircularStackEntry> nextData = <CircularStackEntry>[
      _buildGraph(_noiseDB),
    ];
    setState(() {
      _chartKey.currentState.updateData(nextData);
    });
  }

  CircularStackEntry _buildGraph(double value) {
    return CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(
          value,
          Colors.blue[800],
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          (100 - value),
          Colors.blue[50],
          rankKey: 'remaining',
        ),
      ],
      rankKey: 'progress',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isRecording) {
      _cycleSamples();
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedCircularChart(
              key: _chartKey,
              size: Size(350, 350),
              initialChartData: <CircularStackEntry>[
                _buildGraph(_noiseDB),
              ],
              chartType: CircularChartType.Radial,
              edgeStyle: SegmentEdgeStyle.round,
              percentageValues: true,
              holeLabel: _noiseDB.truncate().toString() + " db",
              labelStyle: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 62,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        onPressed: () {
          if (!this._isRecording) {
            return this.startRecorder();
          }
          this.stopRecorder();
        },
        child: Icon(
          this._isRecording ? Icons.stop : Icons.mic,
        ),
      ),
    );
  }
}
