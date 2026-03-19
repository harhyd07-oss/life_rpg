// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalyticsModelAdapter extends TypeAdapter<AnalyticsModel> {
  @override
  final int typeId = 5;

  @override
  AnalyticsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyticsModel(
      totalHabitsCompleted: fields[0] as int,
      totalDailiesCompleted: fields[1] as int,
      totalTodosCompleted: fields[2] as int,
      totalXpEarned: fields[3] as int,
      bestStreak: fields[4] as int,
      dailyCompletions: (fields[5] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, AnalyticsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.totalHabitsCompleted)
      ..writeByte(1)
      ..write(obj.totalDailiesCompleted)
      ..writeByte(2)
      ..write(obj.totalTodosCompleted)
      ..writeByte(3)
      ..write(obj.totalXpEarned)
      ..writeByte(4)
      ..write(obj.bestStreak)
      ..writeByte(5)
      ..write(obj.dailyCompletions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
