import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../../components/player/fire_point.dart';
import '../../components/shared/health_component.dart';
import 'dart:math';
import '../../xenon_game.dart';
import '../../components/shared/shooting_system.dart';
import '../powerups/base_powerup.dart';
import '../powerups/heal_powerup.dart';
import '../powerups/extra_firepoint_powerup.dart';
import '../powerups/screen_clear_powerup.dart';
import '../powerups/rapid_fire_powerup.dart';

class BaseEnemy extends SpriteComponent with HasGameRef<XenonGame> {
  late HealthComponent health;
  late ShootingSystem shootingSystem;
  late FirePoint firePoint;
  final Random _random = Random();
  Vector2? _targetPosition;
  final double moveSpeed = 100;
  bool _isInitialized = false;

  BaseEnemy() : super(size: Vector2(50, 50)) {
    add(RectangleHitbox(
      size: Vector2(80, 80),
      position: Vector2(24, 24),
    )..collisionType = CollisionType.active);
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Load the enemy sprite.
    sprite = await Sprite.load('enemy_ship.png');
    size = Vector2(128, 128);
    angle = 3 * pi / 2;

    // Initialize components
    await _initializeComponents();

    // Pick initial target after initialization
    pickNewTarget();
  }

  Future<void> _initializeComponents() async {
    if (!_isInitialized) {
      // Initialize the health component.
      health = HealthComponent(
        maxHealth: 1,
        onDeath: handleDeath,
      );
      add(health);

      // Initialize the shooting system with random interval
      shootingSystem = ShootingSystem();
      _resetShootingCooldown();
      add(shootingSystem);

      // Add fire point
      firePoint = FirePoint(
        position: Vector2(size.x / 2, -20),
      );
      add(firePoint);

      _isInitialized = true;
    }
  }

  @override
  void onMount() {
    super.onMount();
    // Pick new target when mounted
    pickNewTarget();
  }

  void _resetShootingCooldown() {
    final randomInterval = 2.0 + _random.nextDouble() * 4.0;
    shootingSystem.initCooldown(randomInterval);
  }

  Vector2 getBulletSpawnPosition() {
    return firePoint.absolutePosition;
  }

  @override
  void update(double dt) {
    super.update(dt);
    shootingSystem.update(dt);

    if (shootingSystem.attemptShoot(this)) {
      _resetShootingCooldown();
    }

    // Move towards target position
    if (_targetPosition != null) {
      final direction = _targetPosition! - position;
      if (direction.length > 5) {
        position += direction.normalized() * moveSpeed * dt;
      } else {
        pickNewTarget();
      }
    }
  }

  void takeDamage(int damage) {
    gameRef.scoreBloc.incrementScore();

    // Random chance to drop power-up (20% chance)
    if (_random.nextDouble() < 0.2) {
      _dropRandomPowerUp();
    }

    gameRef.poolManager.enemyPool.release(this);
  }

  void _dropRandomPowerUp() {
    final powerUpType = _random.nextInt(4);
    BasePowerUp powerUp;

    switch (powerUpType) {
      case 0:
        powerUp = HealPowerUp();
        break;
      case 1:
        powerUp = ExtraFirePointPowerUp();
        break;
      case 2:
        powerUp = ScreenClearPowerUp();
        break;
      case 3:
        powerUp = RapidFirePowerUp();
        break;
      default:
        powerUp = HealPowerUp();
    }

    powerUp.position = position;
    gameRef.add(powerUp);
  }

  void handleDeath() {
    gameRef.scoreBloc.incrementScore();
    gameRef.poolManager.enemyPool.release(this);
  }

  void reset() {
    if (_isInitialized) {
      health.reset();
      _targetPosition = null;
      _resetShootingCooldown();
      pickNewTarget(); // Pick new target when reset
    }
  }

  void pickNewTarget() {
    if (_isInitialized) {
      final screenSize = gameRef.size;
      final minX = screenSize.x * 0.6;
      final maxX = screenSize.x - size.x - 20;
      final minY = size.y; // Top padding
      final maxY = screenSize.y - 20; // Minimal bottom padding

      final randomX = position.x + (_random.nextDouble() * 200 - 100);
      final randomY = position.y + (_random.nextDouble() * 300 - 150);

      _targetPosition = Vector2(
        randomX.clamp(minX, maxX).toDouble(),
        randomY.clamp(minY, maxY).toDouble(),
      );
    }
  }
}
