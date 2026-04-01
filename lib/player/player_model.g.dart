// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerModelAdapter extends TypeAdapter<PlayerModel> {
  @override
  final int typeId = 0;

  @override
  PlayerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerModel(
      xp: fields[0] as int,
      level: fields[1] as int,
      gold: fields[2] as int,
      health: fields[3] as int,
      legacyClassIndex: fields[4] as int,
      warriorPoints: fields[5] as int,
      magePoints: fields[6] as int,
      roguePoints: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.xp)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.gold)
      ..writeByte(3)
      ..write(obj.health)
      ..writeByte(4)
      ..write(obj.legacyClassIndex)
      ..writeByte(5)
      ..write(obj.warriorPoints)
      ..writeByte(6)
      ..write(obj.magePoints)
      ..writeByte(7)
      ..write(obj.roguePoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
