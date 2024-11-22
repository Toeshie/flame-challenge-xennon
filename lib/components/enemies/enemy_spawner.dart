import 'dart:math';
import 'package:flame/components.dart';
import '../../../xenon_game.dart';

class EnemySpawner extends Component with HasGameRef<XenonGame> {
  late Timer _spawnTimer;
  final Random _random = Random();
  double _lastMultiplier = 1.0;

  EnemySpawner();

  @override
  void onMount() {
    super.onMount();
    _resetSpawnTimer();
  }

  void _resetSpawnTimer() {
    const baseTime = 3.0;
    final multiplier = gameRef.scoreBloc.state.spawnTimeMultiplier;
    final adjustedTime = baseTime * multiplier;

    _spawnTimer = Timer(
      adjustedTime,
      repeat: true,
      onTick: _spawnEnemy,
    );
    _spawnTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Check if multiplier has changed
    final currentMultiplier = gameRef.scoreBloc.state.spawnTimeMultiplier;
    if (_lastMultiplier != currentMultiplier) {
      _lastMultiplier = currentMultiplier;
      _resetSpawnTimer();
    }

    _spawnTimer.update(dt);
  }

  void _spawnEnemy() {
    final screenSize = gameRef.size;
    final enemySize = Vector2(128, 128);

    final minX = screenSize.x * 0.6;
    final maxX = screenSize.x - enemySize.x;
    final minY = enemySize.y;
    final maxY = screenSize.y - 20;

    final spawnX = minX + (_random.nextDouble() * (maxX - minX));
    final spawnY = minY + (_random.nextDouble() * (maxY - minY));

    final enemy = gameRef.poolManager.enemyPool.spawn()
      ..position = Vector2(spawnX, spawnY)
      ..size = enemySize;

    gameRef.add(enemy);

    // Pick new target after adding to game
    enemy.pickNewTarget();
  }
}
