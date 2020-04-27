import 'package:flutter/material.dart';

class Track {
  List _sound;
  String _date;

  Track({@required List sound, @required String date}) {
    this._sound = sound;
    this._date = date;
  }

  List getSound() {
    return _sound;
  }

  String getDate() {
    return _date;
  }

  Track.fromJson(Map<String, dynamic> json)
      : _sound = json['sound'].split(',').toList(),
        _date = json['date'];

  Map<String, dynamic> toJson() => {
        'sound': _sound.toString(),
        'date': _date,
      };

  @override
  String toString() {
    return "Valori: " + getSound().toString() + " - Data: " + getDate();
  }
}
