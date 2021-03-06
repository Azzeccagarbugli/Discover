import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'track.g.dart';

@HiveType(typeId: 0)
class Track {
  @HiveField(0)
  final List<double> sound;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final bool isSaved;

  Track({
    @required this.sound,
    @required this.date,
    @required this.isSaved,
  });
}
