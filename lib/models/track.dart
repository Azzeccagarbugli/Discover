import 'package:flutter/material.dart';

class Track {
  List<double> _sound;
  String _date;

  Track({@required List<double> sound, @required String date}) {
    this._sound = sound;
    this._date = date;
  }

  List<double> getSound() {
    return _sound;
  }

  String getDate() {
    return _date;
  }

  Track.fromJson(Map<String, dynamic> json)
      : _sound = json['sound'],
        _date = json['date'];

  Map<String, dynamic> toJson() => {
        'sound': _sound,
        'date': _date,
      };

  @override
  String toString() {
    return "Valori " + getSound().toString() + " - Data: " + getDate();
  }
}
