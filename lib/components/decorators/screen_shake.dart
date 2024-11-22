import 'dart:math';
import 'package:flame/components.dart';

class ScreenShakeComponent extends Component {
  final Random _random = Random();
  double _elapsedTime = 0;
  final double _duration;
  final double _intensity;
  Vector2 _originalPosition = Vector2.zero();
  final CameraComponent camera;
  Vector2 _shakeOffset = Vector2.zero();

  ScreenShakeComponent({
    required this.camera,
    double duration = 0.3,
    double intensity = 5.0,
  })  : _duration = duration,
        _intensity = intensity;

  @override
  void onMount() {
    super.onMount();
    _originalPosition = camera.viewfinder.position.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;

    if (_elapsedTime < _duration) {
      // Store previous shake offset
      _shakeOffset = Vector2(
        _random.nextDouble() * _intensity * 2 - _intensity,
        _random.nextDouble() * _intensity * 2 - _intensity,
      );

      // Apply new offset relative to original position
      camera.viewfinder.position = _originalPosition + _shakeOffset;
    } else {
      // Reset camera position and remove component
      camera.viewfinder.position = _originalPosition;
      removeFromParent();
    }
  }

  @override
  void onRemove() {
    // Ensure camera is reset to original position
    camera.viewfinder.position = _originalPosition;
    super.onRemove();
  }
}
