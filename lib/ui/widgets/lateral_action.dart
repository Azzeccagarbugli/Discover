import 'package:Discover/models/track.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';

class LateralAction extends StatelessWidget {
  final Track trk;
  final int pos;
  final Box<Track> tracks;

  final Color color;
  final Function onTap;
  final IconData icon;
  final bool closeOnTap;

  const LateralAction({
    this.trk,
    @required this.pos,
    this.tracks,
    @required this.color,
    @required this.onTap,
    this.icon,
    @required this.closeOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
        child: IconSlideAction(
          closeOnTap: closeOnTap,
          icon: trk != null
              ? (trk.isSaved ? Icons.favorite : Icons.favorite_border)
              : icon,
          color: color,
          onTap: onTap,
        ),
      ),
    );
  }
}
