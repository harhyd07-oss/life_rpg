import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'player_model.dart';

final playerProvider = StateProvider<Player>((ref) {
  return Player.initial();
});
