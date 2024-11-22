import 'package:flutter/material.dart';
import '../xenon_game.dart';

class ClickToStartOverlay extends StatelessWidget {
  final XenonGame game;

  const ClickToStartOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapDown: (_) {
          game.handleInteraction();
          game.resumeEngine();
        },
        child: Container(
          color: Colors.transparent,
          child: const Center(
            child: Text(
              'Click to Start',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
