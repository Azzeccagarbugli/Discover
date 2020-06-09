import 'dart:io';
import 'dart:math';

import 'package:Discover/models/level.dart';
import 'package:Discover/models/track.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

String getTitle(Track track) {
  return "Track recorded ${DateFormat('EEEE, MMM d').format(track.date)}";
}

Future<String> pathFile(Track track) async {
  var output = await getTemporaryDirectory();
  return '${output.path}/${getTitle(track)}.pdf';
}

Future<File> generateResume(Track track) async {
  final pdf = pw.Document();

  final pw.PageTheme pageTheme = await _myPageTheme();

  pdf.addPage(
    pw.Page(
      pageTheme: pageTheme,
      build: (pw.Context context) {
        return pw.Column(
          children: <pw.Widget>[
            pw.Expanded(
              child: pw.Container(
                child: pw.Row(
                  children: <pw.Widget>[
                    pw.Expanded(
                      flex: 3,
                      child: _DataTitle(track: track),
                    ),
                    pw.Expanded(
                      flex: 5,
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: <pw.Widget>[
                          _InfoPDF(
                            track: track,
                            level: Level.HIGH,
                          ),
                          _InfoPDF(
                            track: track,
                            level: Level.AVG,
                          ),
                          _InfoPDF(
                            track: track,
                            level: Level.MIN,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: _GraphPDF(
                track: track,
              ),
            ),
          ],
        );
      },
    ),
  );

  final file = File(await pathFile(track));

  file.writeAsBytes(pdf.save());

  return file;
}

Future<pw.PageTheme> _myPageTheme() async {
  return pw.PageTheme(
    pageFormat: PdfPageFormat.a4.landscape,
    margin: pw.EdgeInsets.all(16),
    theme: pw.ThemeData.withFont(
      base: pw.Font.ttf(
        await rootBundle.load(
          "assets/fonts/Quicksand-Regular.ttf",
        ),
      ),
    ),
  );
}

class _DataTitle extends pw.StatelessWidget {
  _DataTitle({
    this.track,
  });

  final Track track;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.SizedBox(
          height: 16,
        ),
        pw.Text(
          "Discover",
          style: pw.TextStyle(
            fontSize: 42,
            color: PdfColors.grey800,
          ),
        ),
        pw.Text(
          DateFormat('EEEE, MMM d').format(track.date),
          style: pw.TextStyle(
            fontSize: 26,
            color: PdfColors.grey600,
          ),
        ),
        pw.SizedBox(
          height: 8,
        ),
        pw.Text(
          "Recorded at ${DateFormat('hh:mm a').format(track.date)}",
          style: pw.TextStyle(
            fontSize: 24,
            color: PdfColors.grey500,
          ),
        ),
      ],
    );
  }
}

class _GraphPDF extends pw.StatelessWidget {
  _GraphPDF({this.track});

  final Track track;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Chart(
      grid: pw.CartesianGrid(
        xAxis: pw.FixedAxis(
          List.generate(track.sound.length, (index) => index),
          format: (num l) {
            return "";
          },
        ),
        yAxis: pw.FixedAxis(
          [0, 20, 40, 60, 80, 100],
          divisions: true,
          format: (v) => "$v db",
          textStyle: pw.TextStyle(
            color: PdfColors.grey800,
          ),
        ),
      ),
      datasets: [
        pw.LineDataSet(
          drawSurface: true,
          isCurved: true,
          drawPoints: false,
          color: PdfColors.blue800,
          data: List<pw.LineChartValue>.generate(
            track.sound.length,
            (i) {
              final num v = track.sound[i];
              return pw.LineChartValue(
                i.toDouble(),
                v.toDouble(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _InfoPDF extends pw.StatelessWidget {
  _InfoPDF({this.level, this.track});

  final Level level;
  final Track track;

  double buildVal(Level level, Track track) {
    switch (level) {
      case Level.HIGH:
        return track.sound.reduce(max);
      case Level.AVG:
        return track.sound.reduce((a, b) => a + b) / track.sound.length;
      case Level.MIN:
        return track.sound.reduce(min);
      default:
        return null;
    }
  }

  String buildText(Level level) {
    switch (level) {
      case Level.HIGH:
        return "MAX";
      case Level.AVG:
        return "AVG";
      case Level.MIN:
        return "MIN";
      default:
        return null;
    }
  }

  PdfColor buildColor(Level level) {
    switch (level) {
      case Level.HIGH:
        return PdfColors.red600;
      case Level.AVG:
        return PdfColors.blue800;
      case Level.MIN:
        return PdfColors.green400;
      default:
        return null;
    }
  }

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      width: 150,
      height: 150,
      decoration: pw.BoxDecoration(
        color: buildColor(level),
        borderRadius: 25,
      ),
      child: pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: <pw.Widget>[
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: pw.Row(
                children: <pw.Widget>[
                  pw.Text(
                    buildVal(level, track).toStringAsFixed(0),
                    style: pw.TextStyle(
                      fontSize: 68,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.Text(
                    "db",
                    style: pw.TextStyle(
                      fontSize: 22,
                      color: PdfColors.white,
                    ),
                  ),
                ],
              ),
            ),
            pw.Text(
              buildText(level),
              style: pw.TextStyle(
                fontSize: 18,
                color: PdfColors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
