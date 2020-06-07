import 'dart:typed_data';

import 'package:Discover/models/track.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateResume(Track track) async {
  final pdf = pw.Document(
    author: "Francesco Coppola",
    title: DateFormat('Track recorded EEEE, MMM d').format(track.date),
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text(
            "Hello World",
          ),
        );
      },
    ),
  );

  return pdf.save();
}
