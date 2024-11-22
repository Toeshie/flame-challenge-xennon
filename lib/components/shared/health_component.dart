import 'package:flame/components.dart';
import '../../xenon_game.dart';

class HealthComponent extends Component with HasGameRef<XenonGame> {
  int maxHealth;
  int currentHealth;
  Function? onDeathCallback;

  HealthComponent({
    required this.maxHealth,
    Function? onDeath,
  })  : currentHealth = maxHealth,
        onDeathCallback = onDeath;

  void takeDamage(int damage) {
    currentHealth -= damage;
    if (currentHealth <= 0) {
      currentHealth = 0;
      onDeath();
    }
    _updateBloc();
  }

  void heal(int amount) {
    currentHealth = (currentHealth + amount).clamp(0, maxHealth);
    _updateBloc();
  }

  void _updateBloc() {
    gameRef.healthBloc.updateHealth(currentHealth, maxHealth);
  }

  void onDeath() {
    if (onDeathCallback != null) {
      onDeathCallback!();
    } else {
      // Default behavior if no callback is provided
    }
  }

  void reset() {
    currentHealth = maxHealth;
  }
}
