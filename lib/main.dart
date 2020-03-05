import 'dart:async';
import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:spring_button/spring_button.dart';

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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter;

  bool _micVisibility = true;

  double _noiseDB = 0;
  double _maxNoiseDB = 0;
  double _minNoiseDB = 0;

  int _selectedIndex = 0;

  Color color = Colors.blue[100].withAlpha(60);

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 500,
      ),
      vsync: this,
    )..forward();
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
      _buildGraphMaxNoise(_maxNoiseDB),
      _buildGraphMinNoise(_minNoiseDB),
      _buildGraphActualNoise(_noiseDB),
    ];

    setState(() {
      if (_noiseDB > _maxNoiseDB) {
        _maxNoiseDB = _noiseDB;
      }
      if (_minNoiseDB > _noiseDB) {
        _minNoiseDB = _noiseDB;
      }
      _chartKey.currentState.updateData(nextData);
    });
  }

  CircularStackEntry _buildGraphActualNoise(double value) {
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

  CircularStackEntry _buildGraphMaxNoise(double value) {
    return CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(
          value,
          Colors.red,
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          (100 - value),
          Colors.red[50],
          rankKey: 'remaining',
        ),
      ],
      rankKey: 'progress',
    );
  }

  CircularStackEntry _buildGraphMinNoise(double value) {
    return CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(
          value,
          Colors.green[400],
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          (100 - value),
          Colors.green[50],
          rankKey: 'remaining',
        ),
      ],
      rankKey: 'progress',
    );
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  void _setColor(double value) {
    if (value > 90) {
      color = Colors.red[700].withAlpha(60);
    } else {
      color = Colors.blue[100].withAlpha(60);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isRecording) {
      _cycleSamples();
      _setColor(_noiseDB);
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // _isRecording
          //     ? Positioned.fill(child: AnimatedBackground())
          //     : SizedBox(),
          _isRecording
              ? onBottom(
                  AnimatedWave(height: _noiseDB * 2, speed: 1.0, color: color))
              : SizedBox(),
          _isRecording
              ? onBottom(AnimatedWave(
                  height: (_minNoiseDB + 20) * 3,
                  speed: 0.9,
                  offset: pi,
                  color: color,
                ))
              : SizedBox(),
          _isRecording
              ? onBottom(AnimatedWave(
                  height: _maxNoiseDB * 2.5,
                  speed: 1.2,
                  offset: pi / 2,
                  color: color,
                ))
              : SizedBox(),
          Center(
            child: FlipCard(
              flipOnTouch: true,
              back: Stack(
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
                      child: Container(
                        height: 350,
                        width: 350,
                        child: Icon(
                          Icons.linked_camera,
                          size: 30,
                        ),
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
                            color: this._isRecording
                                ? Colors.red[600]
                                : Colors.white,
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
                            color: this._isRecording
                                ? Colors.white
                                : Colors.blue[800],
                            size: 64,
                          ),
                        ),
                        onTap: () {
                          if (!this._isRecording) {
                            return this.startRecorder();
                          }
                          this.stopRecorder();
                        },
                        useCache: false,
                      ),
                    ),
                  ),
                ],
              ),
              front: Stack(
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
                      child: AnimatedCircularChart(
                        key: _chartKey,
                        size: Size(350, 350),
                        initialChartData: <CircularStackEntry>[
                          _buildGraphMaxNoise(_maxNoiseDB),
                          _buildGraphMinNoise(_minNoiseDB),
                          _buildGraphActualNoise(_noiseDB),
                        ],
                        chartType: CircularChartType.Radial,
                        edgeStyle: SegmentEdgeStyle.round,
                        percentageValues: true,
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
                            color: this._isRecording
                                ? Colors.red[600]
                                : Colors.white,
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
                            color: this._isRecording
                                ? Colors.white
                                : Colors.blue[800],
                            size: 64,
                          ),
                        ),
                        onTap: () {
                          if (!this._isRecording) {
                            return this.startRecorder();
                          }
                          this.stopRecorder();
                        },
                        useCache: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 36,
            left: 24,
            right: 24,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(62),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: -10,
                    blurRadius: 60,
                    color: Colors.black.withOpacity(.20),
                    offset: Offset(0, 15),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10,
                ),
                child: GNav(
                    gap: 8,
                    textStyle: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    color: Colors.grey[800],
                    activeColor: Colors.blue[800],
                    iconSize: 24,
                    // backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    duration: Duration(
                      milliseconds: 800,
                    ),
                    tabs: [
                      GButton(
                        active: true,
                        icon: Icons.hearing,
                        text: 'Listen',
                        backgroundColor: Colors.blue[50],
                      ),
                      GButton(
                        icon: Icons.library_books,
                        text: 'Tracks',
                        backgroundColor: Colors.blue[50],
                      ),
                      GButton(
                        icon: Icons.favorite,
                        text: 'Saved',
                        backgroundColor: Colors.blue[50],
                      ),
                      GButton(
                        icon: Icons.settings,
                        text: 'Settings',
                        backgroundColor: Colors.blue[50],
                      ),
                    ],
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      print(index);
                      setState(() {
                        _selectedIndex = index;
                      });
                    }),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blue[800],
      //   onPressed: () {
      //     if (!this._isRecording) {
      //       return this.startRecorder();
      //     }
      //     this.stopRecorder();
      //   },
      //   child: Icon(
      //     this._isRecording ? Icons.stop : Icons.mic,
      //   ),
      // ),
    );
  }
}

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffD38312), end: Colors.lightBlue.shade900)),
      Track("color2").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffA83279), end: Colors.blue.shade600))
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                animation["color1"],
                animation["color2"],
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;
  final Color color;

  AnimatedWave({
    this.height,
    this.speed,
    this.offset = 0.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: ControlledAnimation(
          playback: Playback.LOOP,
          duration: Duration(milliseconds: (5000 / speed).round()),
          tween: Tween(begin: 0.0, end: 2 * pi),
          builder: (context, value) {
            return CustomPaint(
              foregroundPainter: CurvePainter(value + offset, color),
            );
          },
        ),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;
  final Color color;

  CurvePainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = this.color;
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
