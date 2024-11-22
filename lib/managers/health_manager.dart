import 'package:flutter_bloc/flutter_bloc.dart';

class HealthState {
  final int currentHealth;
  final int maxHealth;

  HealthState({
    required this.currentHealth,
    required this.maxHealth,
  });
}

class HealthBloc extends Cubit<HealthState> {
  HealthBloc() : super(HealthState(currentHealth: 5, maxHealth: 5));

  void updateHealth(int current, int max) {
    emit(HealthState(currentHealth: current, maxHealth: max));
  }
}
