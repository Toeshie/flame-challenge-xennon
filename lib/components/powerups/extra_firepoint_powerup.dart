import '../../components/player/player.dart';
import 'base_powerup.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class ExtraFirePointPowerUp extends BasePowerUp {
  static const Duration duration = Duration(seconds: 10);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final image = await gameRef.images.load('firepoint_spritesheet.png');
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
    player.activateExtraFirePoints(duration);
    gameRef.audioManager.playExtraFirePointPowerUpSound();
  }
}
