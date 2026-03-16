// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyAdapter extends TypeAdapter<Daily> {
  @override
  final int typeId = 2;

  @override
  Daily read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Daily(
      id: fields[0] as String,
      title: fields[1] as String,
      completedToday: fields[2] as bool,
      streak: fields[3] as int,
      lastCompletedDate: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Daily obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.completedToday)
      ..writeByte(3)
      ..write(obj.streak)
      ..writeByte(4)
      ..write(obj.lastCompletedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
