import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import '../../xenon_game.dart';
import 'package:flutter/painting.dart' show ImageRepeat;

class Background extends ParallaxComponent<XenonGame> {
  @override
  Future<void> onLoad() async {
    parallax = await Parallax.load(
      [
        ParallaxImageData('background.png'),
      ],
      baseVelocity: Vector2(-50, 0),
      repeat: ImageRepeat.repeat,
      fill: LayerFill.height,
    );
  }
}
