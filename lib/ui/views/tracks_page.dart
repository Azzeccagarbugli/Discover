import 'package:Discover/controllers/sharedpref.dart';
import 'package:Discover/models/track.dart';
import 'package:flutter/material.dart';

class TracksView extends StatefulWidget {
  @override
  _TracksViewState createState() => _TracksViewState();
}

class _TracksViewState extends State<TracksView> {
  SharedPref _sharedPref = SharedPref();

  Track _trk = Track(sound: [], date: "");

  _loadSharedPrefs() async {
    try {
      Track trk = Track.fromJson(await _sharedPref.read("track"));
      print("HEY" + trk.toString());
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("Loaded!"),
          duration: const Duration(milliseconds: 500)));
      setState(() {
        _trk = trk;
      });
    } catch (Excepetion) {
      print(Excepetion);
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("Nothing found!"),
          duration: const Duration(milliseconds: 500)));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            _trk.toString(),
            style: TextStyle(color: Colors.grey[900]),
          ),
        ),
      ),
    );
  }
}
