import 'dart:convert';

import 'package:Discover/controllers/sharedpref.dart';
import 'package:Discover/models/track.dart';
import 'package:flutter/material.dart';

class TracksView extends StatefulWidget {
  @override
  _TracksViewState createState() => _TracksViewState();
}

class _TracksViewState extends State<TracksView> {
  SharedPref _sharedPref = SharedPref();

  List<Track> _listTracks = new List<Track>();

  List<Track> tracksFromStringList(List<String> list) {
    List<Track> tracks = new List<Track>();

    for (String item in list) {
      // print("UN OGGETTO BELLO " + Track.fromJson(json.decode(item)).toString());
      tracks.add(Track.fromJson(json.decode(item)));
    }

    return tracks;
  }

  _loadSharedPrefs() async {
    try {
      // Track trk = Track.fromJson(await _sharedPref.read("track"));
      print("CIAO");

      List<Track> listTracks =
          tracksFromStringList(await _sharedPref.read("track"));

      setState(() {
        _listTracks = listTracks;
      });
    } catch (Excepetion) {
      print(Excepetion);
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
            _listTracks.toString(),
            style: TextStyle(color: Colors.grey[900]),
          ),
        ),
      ),
    );
  }
}
