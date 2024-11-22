import 'dart:math';
import 'package:flame/particles.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ParticleEffects {
  // Power up particle effect
  static ParticleSystemComponent createPowerUpSpiral({
    required Vector2 position,
    required Color color,
    Anchor anchor = Anchor.center,
    double radius = 3,
  }) {
    final random = Random();

    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 5,
        lifespan: 0.2,
        generator: (i) {
          final angle = random.nextDouble() * 2 * pi;
          final speed = 20.0 + random.nextDouble() * 30;

          return AcceleratedParticle(
            acceleration: Vector2.zero(),
            speed: Vector2(cos(angle), sin(angle)) * speed,
            position: position.clone(),
            child: CircleParticle(
              radius: 1.5,
              paint: Paint()
                ..color = color.withOpacity(0.7 + random.nextDouble() * 0.3),
            ),
            lifespan: 0.8,
          );
        },
      ),
    );
  }

  static ParticleSystemComponent createWindParticle({
    required Vector2 position,
    required Vector2 size,
  }) {
    final random = Random();

    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 7,
        generator: (i) {
          final startY = random.nextDouble() * size.y;
          final startX = size.x + 20; // Start from right side
          final speed = 30.0 + random.nextDouble() * 20;

          return AcceleratedParticle(
            acceleration: Vector2(-5, random.nextDouble() * 2 - 1),
            speed: Vector2(-speed, 0),
            position: Vector2(startX, startY),
            child: CircleParticle(
              radius: 1 + random.nextDouble(),
              paint: Paint()
                ..color =
                    Colors.green.withOpacity(0.3 + random.nextDouble() * 0.2),
            ),
            lifespan: 3,
          );
        },
      ),
    );
  }

  // Bullet impact particle effect
  static ParticleSystemComponent createBulletImpact({
    required Vector2 position,
    required Color color,
    double scale = 1.0,
  }) {
    final random = Random();

    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 12,
        lifespan: 0.4,
        generator: (i) {
          final speed = 50.0 + random.nextDouble() * 50.0;
          final angle = random.nextDouble() * 2 * pi;
          final velocity = Vector2(cos(angle), sin(angle));

          return AcceleratedParticle(
            acceleration: Vector2(0, 0),
            speed: velocity * speed,
            position: position.clone(),
            child: CircleParticle(
              radius: 1.0 * scale,
              paint: Paint()
                ..color = color.withOpacity(0.8 + random.nextDouble() * 0.2),
            ),
            lifespan: 0.2 + random.nextDouble() * 0.2,
          );
        },
      ),
    );
  }
}
