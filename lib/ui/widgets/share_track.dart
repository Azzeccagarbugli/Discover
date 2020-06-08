import 'dart:io';

import 'package:Discover/models/track.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
                          _InfoPDF(track: track),
                          _InfoPDF(track: track),
                          _InfoPDF(track: track),
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
      bold: pw.Font.ttf(
        await rootBundle.load(
          "assets/fonts/Quicksand-Bold.ttf",
        ),
      ),
    ),
    buildBackground: (pw.Context context) {
      return pw.FullPage(
        ignoreMargins: true,
        child: pw.CustomPaint(
          painter: (PdfGraphics canvas, PdfPoint size) {
            context.canvas
              ..setColor(PdfColors.lightBlue100)
              ..moveTo(0, size.y)
              ..lineTo(0, size.y - 230)
              ..lineTo(60, size.y)
              ..fillPath()
              ..setColor(PdfColors.blue200)
              ..moveTo(0, size.y)
              ..lineTo(0, size.y - 100)
              ..lineTo(100, size.y)
              ..fillPath()
              ..setColor(PdfColors.lightBlue200)
              ..moveTo(30, size.y)
              ..lineTo(110, size.y - 50)
              ..lineTo(150, size.y)
              ..fillPath();
          },
        ),
      );
    },
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
        pw.Text(
          "Discover",
          style: pw.TextStyle(
            fontSize: 42,
            color: PdfColors.grey800,
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: pw.Container(
            width: 200,
            height: 4,
            decoration: pw.BoxDecoration(
              borderRadius: 2,
              color: PdfColors.grey800,
            ),
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
  _InfoPDF({this.track});

  final Track track;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      width: 150,
      height: 150,
      decoration: pw.BoxDecoration(
        color: PdfColors.indigoAccent,
        borderRadius: 25,
      ),
    );
  }
}
