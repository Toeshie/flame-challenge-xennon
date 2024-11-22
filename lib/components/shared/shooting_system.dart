import 'package:flame/components.dart';
import '../../../xenon_game.dart';
import '../../components/player/player.dart';
import '../../components/enemies/base_enemy.dart';
import 'dart:math' as math;

class ShootingSystem extends Component with HasGameRef<XenonGame> {
  bool canShoot = true;
  late Timer _cooldownTimer;

  ShootingSystem();

  void initCooldown(double cooldownInSeconds) {
    _cooldownTimer = Timer(
      cooldownInSeconds,
      onTick: () {
        canShoot = true;
      },
      repeat: true,
    );
    _cooldownTimer.start();
  }

  //Shooting check
  bool attemptShoot(dynamic shooter) {
    if (canShoot) {
      if (shooter is Player) {
        _shootPlayerBullet(shooter);
        gameRef.audioManager.playShootSound();
      } else if (shooter is BaseEnemy) {
        _shootEnemyBullet(shooter);
      }
      canShoot = false;
      _cooldownTimer.reset();
      return true;
    }
    return false;
  }

  void _shootPlayerBullet(Player player) {
    final spawnPositions = player.getBulletSpawnPositions();

    for (final spawnPosition in spawnPositions) {
      final bullet = gameRef.poolManager.playerBulletPool.spawn()
        ..position = spawnPosition
        ..direction = Vector2(1, 0)
        ..speed = 600.0
        ..angle = math.pi / 2;

      gameRef.add(bullet);
    }
  }

  void _shootEnemyBullet(BaseEnemy enemy) {
    if (!gameRef.hasPlayer) return;

    final bulletSpawnPosition = enemy.getBulletSpawnPosition();
    final direction = Vector2(-1, 0);

    final bullet = gameRef.poolManager.enemyBulletPool.spawn()
      ..position = bulletSpawnPosition
      ..direction = direction
      ..speed = 300.0
      ..angle = -math.pi / 2;

    gameRef.add(bullet);
  }

  @override
  void update(double dt) {
    _cooldownTimer.update(dt);
  }

  void stopCooldown() {
    _cooldownTimer.stop();
  }
}
