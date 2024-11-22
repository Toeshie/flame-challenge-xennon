// ignore_for_file: empty_catches

import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  bool _isBgmPlaying = false;

  Future<void> init() async {
    try {
      // Preload all sound effects
      await FlameAudio.audioCache.loadAll([
        'bgm.wav',
        'shoot.wav',
        'hit.wav',
        'heal.wav',
        'clear.wav',
        'extra_fire_pu.wav',
      ]);
    } catch (e) {}
  }

  void playBgm() {
    if (!_isBgmPlaying) {
      try {
        FlameAudio.bgm.play('bgm.wav');
        _isBgmPlaying = true;
      } catch (e) {}
    }
  }

  void stopBgm() {
    try {
      FlameAudio.bgm.stop();
      _isBgmPlaying = false;
    } catch (e) {}
  }

  void playShootSound() {
    try {
      FlameAudio.play('shoot.wav');
    } catch (e) {}
  }

  void playHitSound() {
    try {
      FlameAudio.play('hit.wav');
    } catch (e) {}
  }

  void playHealPowerUpSound() {
    try {
      FlameAudio.play('heal.wav');
    } catch (e) {}
  }

  void playClearPowerUpSound() {
    try {
      FlameAudio.play('clear.wav');
    } catch (e) {}
  }

  void playExtraFirePointPowerUpSound() {
    try {
      FlameAudio.play('extra_fire_pu.wav');
    } catch (e) {}
  }

  void dispose() {
    stopBgm();
  }
}
