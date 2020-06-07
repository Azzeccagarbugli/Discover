import 'dart:io';

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
                color: PdfColors.orange,
              ),
            ),
            pw.Expanded(
              child: pw.Center(
                child: pw.Text(
                  "BELLA",
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Container(
                color: PdfColors.pink,
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
    margin: pw.EdgeInsets.all(0),
    theme: pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load(
        "assets/fonts/Quicksand-Regular.ttf",
      )),
      bold: pw.Font.ttf(await rootBundle.load(
        "assets/fonts/Quicksand-Bold.ttf",
      )),
    ),
  );
}
