import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../managers/score_manager.dart';
import '../xenon_game.dart';
import '/managers/health_manager.dart';

class GameUI extends StatelessWidget {
  final XenonGame game;

  const GameUI({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<ScoreBloc, ScoreState>(
            bloc: game.scoreBloc,
            builder: (context, scoreState) {
              final difficultyProgress =
                  (1.0 - scoreState.spawnTimeMultiplier) / 0.7;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Difficulty',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white70),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: difficultyProgress,
                              backgroundColor: Colors.grey.withOpacity(0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(difficultyProgress * 100).toInt()}%',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Score: ${scoreState.score}',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      BlocBuilder<HealthBloc, HealthState>(
                        bloc: game.healthBloc,
                        builder: (context, healthState) {
                          return Row(
                            children: List.generate(
                              healthState.maxHealth,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Icon(
                                  index < healthState.currentHealth
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
