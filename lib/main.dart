import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'xenon_game.dart';
import 'ui/game_ui.dart';
import 'ui/game_over_overlay.dart';
import 'ui/start_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xenon Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GameWidget<XenonGame>.controlled(
          gameFactory: XenonGame.new,
          overlayBuilderMap: {
            'gameUI': (context, game) => GameUI(game: game),
            'gameOver': (context, game) => GameOverOverlay(game: game),
            'clickToStart': (context, game) => ClickToStartOverlay(game: game),
          },
          initialActiveOverlays: const ['gameUI'],
        ),
      ),
    );
  }
}
