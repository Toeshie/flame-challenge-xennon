import '/components/player/player.dart';

abstract class PlayerState {
  final Player player;

  PlayerState(this.player);

  // Each state can define its own shooting cooldown
  double get shootingCooldown;

  //Handle state-specific behavior
  void update(double dt) {}
  void onEnter() {}
  void onExit() {}
}
