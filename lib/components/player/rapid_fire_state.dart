import 'player_state.dart';
import 'normal_state.dart';

class RapidFireState extends PlayerState {
  final Duration duration;
  double _elapsedTime = 0;

  RapidFireState(super.player, {this.duration = const Duration(seconds: 10)});

  @override
  double get shootingCooldown => 0.5;

  @override
  void update(double dt) {
    _elapsedTime += dt;
    if (_elapsedTime >= duration.inSeconds) {
      player.setState(NormalState(player));
    }
  }
}
