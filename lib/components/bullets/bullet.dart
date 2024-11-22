import 'package:flame/components.dart';
import '../../xenon_game.dart';
import 'player_bullet.dart';
import 'enemy_bullet.dart';

abstract class Bullet extends SpriteAnimationComponent
    with HasGameRef<XenonGame> {
  Vector2 get direction;
  set direction(Vector2 value);

  double get speed;
  set speed(double value);

  @override
  void update(double dt) {
    super.update(dt);

    // Update position only
    position += direction * speed * dt;

    // Check if bullet is off screen
    if (position.x < -size.x ||
        position.x > gameRef.size.x + size.x ||
        position.y < -size.y ||
        position.y > gameRef.size.y + size.y) {
      if (this is PlayerBullet) {
        gameRef.poolManager.playerBulletPool.release(this as PlayerBullet);
      } else if (this is EnemyBullet) {
        gameRef.poolManager.enemyBulletPool.release(this as EnemyBullet);
      }
    }
  }
}
