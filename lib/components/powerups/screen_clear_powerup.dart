import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../../components/player/player.dart';
import 'base_powerup.dart';
import '../../components/enemies/base_enemy.dart';
import '../../components/bullets/enemy_bullet.dart';

class ScreenClearPowerUp extends BasePowerUp {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final image = await gameRef.images.load('clear_spritesheet.png');
    anchor = Anchor.center;
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(32, 32),
    );
    animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.05,
      from: 0,
      to: 15,
      loop: true,
    );
  }

  @override
  void activate(Player player) {
    // Clear all enemies
    final enemies = gameRef.children.whereType<BaseEnemy>().toList();
    for (final enemy in enemies) {
      enemy.handleDeath();
    }

    // Clear all enemy bullets
    final bullets = gameRef.children.whereType<EnemyBullet>().toList();
    for (final bullet in bullets) {
      gameRef.poolManager.enemyBulletPool.release(bullet);
    }

    gameRef.audioManager.playClearPowerUpSound();
  }
}
