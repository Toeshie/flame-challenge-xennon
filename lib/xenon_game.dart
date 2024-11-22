import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'components/player/player.dart';
import 'components/enemies/enemy_spawner.dart';
import 'managers/pool_manager.dart';
import 'managers/score_manager.dart';
import 'managers/health_manager.dart';
import 'managers/audio_manager.dart';
import 'package:flame/components.dart';
import 'components/background/background.dart';
import 'components/particles/particle_effects.dart';

class XenonGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final ScoreBloc scoreBloc;
  late final PoolManager poolManager;
  late final Player player;
  late final HealthBloc healthBloc;
  late final AudioManager audioManager;
  bool _isGameOver = false;
  Timer? _windParticleTimer;
  bool _hasInteracted = false;

  XenonGame() {
    pauseWhenBackgrounded = false;

    scoreBloc = ScoreBloc();
    poolManager = PoolManager();
    healthBloc = HealthBloc();
    audioManager = AudioManager();
  }

  bool get isGameOver => _isGameOver;

  void gameOver() {
    _isGameOver = true;
    pauseEngine();
    audioManager.stopBgm();
    overlays.add('gameOver');
  }

  void restart() {
    _isGameOver = false;
    // Reset score
    scoreBloc.resetScore();
    // Reset player
    player.reset();
    // Reset health UI using player's max health
    healthBloc.updateHealth(
        player.healthComponent.maxHealth, player.healthComponent.maxHealth);
    // Clear all enemies and bullets
    poolManager.enemyPool.releaseAll();
    poolManager.enemyBulletPool.releaseAll();
    poolManager.playerBulletPool.releaseAll();
    // Remove game over overlay
    overlays.remove('gameOver');
    audioManager.playBgm();
    resumeEngine();
  }

  @override
  Future<void> onLoad() async {
    await audioManager.init();

    // Add background first
    await add(Background());

    // Initialize wind particle system
    _windParticleTimer = Timer(
      0.2,
      onTick: _spawnWindParticle,
      repeat: true,
    );
    _windParticleTimer?.start();

    await add(poolManager);
    player = Player();
    await add(player);

    final enemySpawner = EnemySpawner();
    await add(enemySpawner);

    // Don't auto-play BGM, wait for interaction
    overlays.add('clickToStart');
  }

  void _spawnWindParticle() {
    final particleSystem = ParticleEffects.createWindParticle(
      position: Vector2.zero(),
      size: size,
    );
    add(particleSystem);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _windParticleTimer?.update(dt);
  }

  bool get hasPlayer => children.whereType<Player>().isNotEmpty;

  @override
  void onRemove() {
    _windParticleTimer?.stop();
    scoreBloc.close();
    audioManager.dispose();
    super.onRemove();
  }

  void handleInteraction() {
    if (!_hasInteracted) {
      _hasInteracted = true;
      overlays.remove('clickToStart');
      audioManager.playBgm();
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!_hasInteracted) {
      pauseEngine();
    }
  }
}
