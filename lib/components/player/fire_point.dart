import 'package:flame/components.dart';
//import 'package:flutter/material.dart' show Canvas, Colors, Offset, Paint;

class FirePoint extends PositionComponent {
  FirePoint({required Vector2 position}) : super(position: position);

  // Only enable this during development to see the fire points
  /* @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      Offset.zero,
      2,
      Paint()..color = Colors.red,
    );
  }*/
}
