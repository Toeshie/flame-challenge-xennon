import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../../components/bullets/bullet.dart';
import '../../components/enemies/base_enemy.dart'; // Import the BaseEnemy class
import 'package:flutter/material.dart' show Colors;
import '../../components/particles/particle_effects.dart';

class PlayerBullet extends Bullet with CollisionCallbacks {
  @override
  Vector2 direction;

  @override
  double speed;

  PlayerBullet({required this.speed, required this.direction}) : super() {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox()..collisionType = CollisionType.active);

    // Load the spritesheet and create animation
    final spriteSheet = await gameRef.images.load('player_bullet.png');
    final animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(8, 16),
      ),
    );

    this.animation = animation;
    size = Vector2(32, 32);
    anchor = Anchor.center;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BaseEnemy) {
      // Create red burst effect
      final burst = ParticleEffects.createBulletImpact(
        position: position,
        color: Colors.red,
        scale: 1.2,
      );
      gameRef.add(burst);

      other.takeDamage(1);
      gameRef.poolManager.playerBulletPool.release(this);
    }
    super.onCollision(intersectionPoints, other);
  }
}
