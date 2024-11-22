import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart' show Colors;
import '../../components/bullets/bullet.dart';
import '../../components/player/player.dart';
import '../../components/particles/particle_effects.dart';

class EnemyBullet extends Bullet with CollisionCallbacks {
  @override
  Vector2 direction;

  @override
  double speed;

  EnemyBullet({required this.speed, required this.direction}) : super() {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox()..collisionType = CollisionType.active);

    final spriteSheet = await gameRef.images.load('enemy_bullet.png');
    final animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: Vector2(16, 32),
      ),
    );

    this.animation = animation;
    size = Vector2(32, 32);
    anchor = Anchor.center;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      // Create burst effect befora adding to pool
      final burst = ParticleEffects.createBulletImpact(
        position: position.clone(),
        color: Colors.green,
        scale: 1.2,
      );
      gameRef.add(burst);

      // add to pool
      gameRef.poolManager.enemyBulletPool.release(this);
    }
    super.onCollision(intersectionPoints, other);
  }
}
