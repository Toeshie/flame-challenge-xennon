import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DamageEffectDecorator extends Component {
  final SpriteComponent target;
  final Duration duration;
  double _elapsedTime = 0;
  static const _flashInterval = 0.1;
  bool _isVisible = true;
  late final Paint _originalPaint;

  DamageEffectDecorator({
    required this.target,
    this.duration = const Duration(milliseconds: 500),
  }) {
    // Create a new Paint object with the same properties
    _originalPaint = Paint()
      ..color = target.paint.color
      ..blendMode = target.paint.blendMode
      ..filterQuality = target.paint.filterQuality
      ..invertColors = target.paint.invertColors
      ..shader = target.paint.shader
      ..colorFilter = target.paint.colorFilter;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;

    // Flash effect
    _isVisible = (_elapsedTime % _flashInterval) < (_flashInterval / 2);
    target.paint.color =
        _isVisible ? Colors.white : Colors.red.withOpacity(0.7);

    // Remove decorator when duration is complete
    if (_elapsedTime >= duration.inMilliseconds / 1000) {
      target.paint.color = _originalPaint.color;
      removeFromParent();
    }
  }

  @override
  void onRemove() {
    target.paint.color = _originalPaint.color;
    super.onRemove();
  }
}
