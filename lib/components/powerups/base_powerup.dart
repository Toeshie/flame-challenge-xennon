import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../../../xenon_game.dart';
import '../../components/player/player.dart';
import 'dart:math' show Random;
import 'package:flutter/material.dart' show Colors, Color;
import '../particles/particle_effects.dart';

abstract class BasePowerUp extends SpriteAnimationComponent
    with HasGameRef<XenonGame>, CollisionCallbacks {
  final double speed = 100.0;
  final Vector2 direction = Vector2(-1, 0); // Move left

  final List<Color> _particleColors = [
    Colors.blue,
    Colors.green,
  ];
  Timer? _particleTimer;
  final Random _random = Random();

  BasePowerUp() : super(size: Vector2(32, 32)) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(
      size: Vector2(24, 24),
      anchor: Anchor.center,
      position: Vector2(16, 16),
    )..collisionType = CollisionType.active);

    // Add particle timer
    _particleTimer = Timer(
      0.1,
      onTick: _spawnParticles,
      repeat: true,
    );
    _particleTimer?.start();
  }

  void _spawnParticles() {
    final color = _particleColors[_random.nextInt(_particleColors.length)];
    final particleSystem = ParticleEffects.createPowerUpSpiral(
      position: position + Vector2(16, 16),
      color: color,
    );
    gameRef.add(particleSystem);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _particleTimer?.update(dt);
    position += direction * speed * dt;

    // Remove if off screen
    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      activate(other);
      removeFromParent();
    }
  }

  void activate(Player player);

  @override
  void onRemove() {
    _particleTimer?.stop();
    super.onRemove();
  }
}
