import 'player_state.dart';

class NormalState extends PlayerState {
  NormalState(super.player);

  @override
  double get shootingCooldown => 1.0;
}
