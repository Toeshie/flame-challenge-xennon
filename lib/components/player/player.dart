import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:flame/collisions.dart';
import '../../components/shared/shooting_system.dart';
import '../../components/bullets/enemy_bullet.dart';
import '../../components/shared/health_component.dart';
import '../../components/player/fire_point.dart';
import '../../../xenon_game.dart';
import '../../components/enemies/base_enemy.dart';
import '../../components/decorators/damage_decorator.dart';
import '../player/player_state.dart';
import '../player/normal_state.dart';

class Player extends SpriteComponent
    with HasGameRef<XenonGame>, CollisionCallbacks, KeyboardHandler {
  final double speed = 300;
  double health = 5;
  Vector2 velocity = Vector2.zero();
  late ShootingSystem shootingSystem;
  late HealthComponent healthComponent;
  late FirePoint firePoint;
  late PlayerState _state;

  Timer? _extraFirePointsTimer;
  bool hasExtraFirePoints = false;

  List<FirePoint> extraFirePoints = [];
  static const double extraFirePointOffset = 30.0;

  void _clampPosition() {
    final gameSize = gameRef.size;
    final halfWidth = size.x / 2;
    final halfHeight = size.y / 2;

    // Clamp X position
    position.x = position.x.clamp(
      halfWidth, // Left boundary
      gameSize.x - halfWidth, // Right boundary
    );

    // Clamp Y position
    position.y = position.y.clamp(
      size.y * 0.2, //top margin
      gameSize.y - halfHeight, // Bottom boundary
    );
  }

  @override
  Future<void>? onLoad() async {
    // Load player sprite and set initial position and size
    sprite = await Sprite.load('MainShip.png');
    size = Vector2(128, 128);
    position = Vector2(100, 100);
    angle = math.pi / 2;

    // Add a hitbox
    add(RectangleHitbox(
      size: Vector2(80, 80),
      position: Vector2(24, 24),
    )..collisionType = CollisionType.passive);

    // Initialize and add the shooting system
    _state = NormalState(this);
    shootingSystem = ShootingSystem()..initCooldown(_state.shootingCooldown);
    add(shootingSystem);

    // Add fire point
    firePoint = FirePoint(
      position: Vector2(size.x / 2, -10),
    );
    add(firePoint);
    //Initialize health component
    super.onLoad();
    healthComponent = HealthComponent(
      maxHealth: 5,
      onDeath: handleDeath,
    );
    add(healthComponent);

    // Initialize extra fire points
    extraFirePoints = [
      FirePoint(
        position:
            Vector2(size.x / 2 - extraFirePointOffset, -10), // Left of main
      ),
      FirePoint(
        position:
            Vector2(size.x / 2 + extraFirePointOffset, -10), // Right of main
      ),
    ];

    for (var point in extraFirePoints) {
      add(point);
      point.removeFromParent(); // Remove initially
    }
  }

  List<Vector2> getBulletSpawnPositions() {
    if (hasExtraFirePoints) {
      // Return positions for all fire points
      final allPoints = [firePoint, ...extraFirePoints];
      return allPoints.map((point) => point.absolutePosition).toList();
    }
    return [firePoint.absolutePosition]; // Return list with single position
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    velocity.setZero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      velocity.y = -1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      velocity.y = 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      velocity.x = -1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      velocity.x = 1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      shootingSystem.attemptShoot(this);
    }

    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _extraFirePointsTimer?.update(dt);
    _state.update(dt);

    if (velocity.length != 0) {
      velocity = velocity.normalized() * speed;
      position += velocity * dt;
      _clampPosition();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is EnemyBullet) {
      gameRef.poolManager.enemyBulletPool.release(other);
      takeDamage(1);
    } else if (other is BaseEnemy) {
      takeDamage(1);
    }
  }

  void takeDamage(int damage) {
    healthComponent.takeDamage(damage);
    gameRef.audioManager.playHitSound();

    // Add damage effect decorator
    add(DamageEffectDecorator(
      target: this,
      duration: const Duration(milliseconds: 500),
    ));
  }

  void heal(int amount) {
    healthComponent.heal(amount);
    if (healthComponent.currentHealth > healthComponent.maxHealth) {
      healthComponent.currentHealth = healthComponent.maxHealth;
    }
  }

  void handleDeath() {
    gameRef.gameOver();
  }

  @override
  void onRemove() {
    // Stop the shooting system cooldown when the player is removed
    shootingSystem.stopCooldown();
    super.onRemove();
  }

  void activateExtraFirePoints(Duration duration) {
    hasExtraFirePoints = true;
    // Add extra fire points back to the player
    for (var point in extraFirePoints) {
      add(point);
    }

    _extraFirePointsTimer?.stop();
    _extraFirePointsTimer = Timer(
      duration.inSeconds.toDouble(),
      onTick: () {
        hasExtraFirePoints = false;
        // Remove extra fire points when power-up expires
        for (var point in extraFirePoints) {
          point.removeFromParent();
        }
      },
    );
  }

  void reset() {
    position = Vector2(100, 100);
    healthComponent.reset();
    hasExtraFirePoints = false;
    for (var point in extraFirePoints) {
      point.removeFromParent();
    }
  }

  void setState(PlayerState newState) {
    _state.onExit();
    _state = newState;
    _state.onEnter();
    // Update shooting cooldown when state changes
    shootingSystem.initCooldown(_state.shootingCooldown);
  }
}
