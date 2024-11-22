import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ScoreEvent {}

class IncrementScore extends ScoreEvent {}

class ResetScore extends ScoreEvent {}

// State
class ScoreState {
  final int score;
  final double spawnTimeMultiplier;

  ScoreState({
    this.score = 0,
    this.spawnTimeMultiplier = 1.0,
  });

  double calculateSpawnTimeMultiplier(int score) {
    // Start at 1.0 and decrease to 0.3 (about 3x faster at max)
    const minMultiplier = 0.3;
    const scoreForMaxDifficulty = 70;

    if (score >= scoreForMaxDifficulty) {
      return minMultiplier;
    }

    final multiplier =
        1.0 - (score / scoreForMaxDifficulty) * (1.0 - minMultiplier);
    return multiplier.clamp(minMultiplier, 1.0);
  }

  ScoreState copyWith({
    int? score,
    double? spawnTimeMultiplier,
  }) {
    return ScoreState(
      score: score ?? this.score,
      spawnTimeMultiplier: spawnTimeMultiplier ?? this.spawnTimeMultiplier,
    );
  }
}

// Bloc
class ScoreBloc extends Cubit<ScoreState> {
  ScoreBloc() : super(ScoreState());

  void incrementScore() {
    final newScore = state.score + 1;
    final newMultiplier = state.calculateSpawnTimeMultiplier(newScore);

    emit(state.copyWith(
      score: newScore,
      spawnTimeMultiplier: newMultiplier,
    ));
  }

  void resetScore() {
    emit(ScoreState());
  }
}
