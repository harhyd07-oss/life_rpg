import 'package:hive/hive.dart';

part 'reward_model.g.dart';

@HiveType(typeId: 4)
class Reward {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int goldCost;

  @HiveField(3)
  final DateTime createdAt;

  Reward({
    required this.id,
    required this.title,
    required this.goldCost,
    required this.createdAt,
  });

  Reward copyWith({
    String? id,
    String? title,
    int? goldCost,
    DateTime? createdAt,
  }) {
    return Reward(
      id: id ?? this.id,
      title: title ?? this.title,
      goldCost: goldCost ?? this.goldCost,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
