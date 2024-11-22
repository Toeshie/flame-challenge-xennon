import 'package:flame/components.dart';
import '../../components/enemies/base_enemy.dart';
import '../../components/bullets/player_bullet.dart';
import '../../components/bullets/enemy_bullet.dart';
import '../utils/object_pool.dart';

class PoolManager extends Component with HasGameRef {
  late ObjectPool<BaseEnemy> enemyPool;
  late ObjectPool<PlayerBullet> playerBulletPool;
  late ObjectPool<EnemyBullet> enemyBulletPool;

  @override
  Future<void> onLoad() async {
    enemyPool = ObjectPool<BaseEnemy>(
      initialSize: 10,
      factory: () => BaseEnemy(),
      resetFunction: (enemy) {
        enemy.position = Vector2(-1000, -1000);
        enemy.reset();
      },
    );

    playerBulletPool = ObjectPool<PlayerBullet>(
      initialSize: 20,
      factory: () => PlayerBullet(speed: 0, direction: Vector2.zero()),
      resetFunction: (bullet) {
        bullet.position = Vector2(-1000, -1000);
        bullet.direction = Vector2.zero();
        bullet.speed = 0;
      },
    );

    enemyBulletPool = ObjectPool<EnemyBullet>(
      initialSize: 20,
      factory: () => EnemyBullet(speed: 0, direction: Vector2.zero()),
      resetFunction: (bullet) {
        bullet.position = Vector2(-1000, -1000);
        bullet.direction = Vector2.zero();
        bullet.speed = 0;
      },
    );
  }
}
