// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackAdapter extends TypeAdapter<Track> {
  @override
  final typeId = 0;

  @override
  Track read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Track(
      sound: (fields[0] as List)?.cast<dynamic>(),
      date: fields[1] as String,
      isSaved: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Track obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.sound)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.isSaved);
  }
}
