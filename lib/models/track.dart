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

  void reset() {
    if (this._sound.isNotEmpty) {
      this._sound.clear();
    }
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Valori " + getSound().toString() + " - Data: " + getDate();
  }
}
